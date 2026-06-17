#!/usr/bin/env bash
# Egress allowlist for the devenv agent sandbox.
#
# Default-deny outbound: only the domains listed below — plus DNS, loopback,
# the host network, and GitHub's published CIDR ranges — are reachable.
# Everything else is REJECTed. Modelled on Anthropic's own
# claude-code/.devcontainer/init-firewall.sh.
#
# Runs as root at container start, in agent mode only. Needs NET_ADMIN + NET_RAW.
set -euo pipefail

# ── allowlist ─────────────────────────────────────────────────────────────────
# Everything the caged agent legitimately needs, and nothing else. Edit here.
ALLOWED_DOMAINS=(
    api.github.com
    # Site-local entries (work P4 IP, TeamCity host, etc.) are spliced in HERE at
    # build time from entry/allowlist.local (gitignored, never pushed). Empty in
    # the public repo. Raw IPs/CIDRs are allowed directly; hostnames are resolved.
    # __SITE_LOCAL_ENTRIES__
)

echo "[firewall] initialising egress allowlist..."

# ── start clean (filter table only) ───────────────────────────────────────────
# We deliberately do NOT flush the nat table: Docker/Podman put the embedded
# DNS resolver (127.0.0.11) there, and leaving nat intact keeps name resolution
# working without save/restore gymnastics.
iptables -F
iptables -X
ipset destroy allowed-domains 2>/dev/null || true

# ── baseline allows (added before the default-deny flips on) ───────────────────
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT          # DNS
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT

# Reach the host network (bridge gateway / embedded DNS upstream).
# Delete this block for a stricter cage that can't see the host LAN at all.
# Degrades gracefully: if the gateway can't be determined, skip rather than abort.
HOST_IP="$(ip route show default 2>/dev/null | grep -oE 'via [0-9.]+' | head -1 | cut -d' ' -f2 || true)"
if [[ -n "${HOST_IP:-}" ]]; then
    HOST_NET="${HOST_IP%.*}.0/24"
    echo "[firewall]   host network: $HOST_NET"
    iptables -A OUTPUT -d "$HOST_NET" -j ACCEPT
    iptables -A INPUT  -s "$HOST_NET" -j ACCEPT
else
    echo "[firewall]   WARN: no default route found; skipping host-network allow"
fi

# ── build the allowed-IP set ───────────────────────────────────────────────────
ipset create allowed-domains hash:net

# Add one target to the set: a raw IPv4 / CIDR goes in directly; anything else is
# treated as a hostname and resolved. Site-local entries (which may be bare IPs)
# flow through here too, since they were spliced into ALLOWED_DOMAINS at build.
add_target() {
    local t="$1" ips ip
    if [[ "$t" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}(/[0-9]{1,2})?$ ]]; then
        ipset add allowed-domains "$t" -exist 2>/dev/null \
            || echo "[firewall]   WARN: bad IP/CIDR, skipping: $t"
        return
    fi
    ips="$(dig +short A "$t" | grep -E '^[0-9]+\.' || true)"
    if [[ -z "$ips" ]]; then
        echo "[firewall]   WARN: could not resolve $t"
        return
    fi
    while read -r ip; do ipset add allowed-domains "$ip" -exist; done <<<"$ips"
}

for target in "${ALLOWED_DOMAINS[@]}"; do
    add_target "$target"
done

# ── default-deny, then allow only the set ──────────────────────────────────────
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT
# REJECT (not silent DROP) so blocked calls fail fast instead of hanging.
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "[firewall] egress locked to allowlist."

# ── sanity check ───────────────────────────────────────────────────────────────
# A blocked host must be rejected; an allowed host should be reachable. The
# allowed check retries, because the first DNS lookup right after the lock can
# be slow enough to look like a block when it isn't.
if curl -fsS --max-time 5 https://example.com >/dev/null 2>&1; then
    echo "[firewall] ERROR: example.com reachable - leash is NOT holding" >&2
    exit 1
fi

allowed_ok=""
for _ in 1 2 3; do
    if curl -fsS --max-time 5 https://api.github.com/zen >/dev/null 2>&1; then
        allowed_ok=1
        break
    fi
    sleep 1
done

if [[ -n "$allowed_ok" ]]; then
    echo "[firewall] verified: blocked host rejected, allowed host reachable."
else
    echo "[firewall] WARN: blocked host rejected, but api.github.com check failed after retries - allowlist may be too tight" >&2
fi

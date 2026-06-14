#!/usr/bin/env bash
set -euo pipefail
CONTAINER="devenv"
NO_TMUX="${NO_TMUX:-}"

# Pick container engine: explicit override, else docker, else podman.
ENGINE="${CONTAINER_ENGINE:-}"
if [[ -z "$ENGINE" ]]; then
    if command -v docker &>/dev/null; then
        ENGINE="docker"
    elif command -v podman &>/dev/null; then
        ENGINE="podman"
    else
        echo "Neither docker nor podman is installed." >&2
        exit 1
    fi
fi

# Flags so nested podman works inside the devenv regardless of the outer engine.
#   - both:   /dev/fuse, for the inner podman's fuse-overlayfs storage driver
#   - podman: keep SELinux enforcing (container_engine_t) and map the host user
#             to the container's dev (uid 1000) via keep-id so bind mounts stay
#             writable (both podman-only)
#   - docker: relax seccomp, since Docker's default profile blocks the
#             namespace/clone syscalls rootless podman needs in order to nest
ENGINE_RUN_ARGS=(--device /dev/fuse --device /dev/net/tun)
if [[ "$ENGINE" == "podman" ]]; then
    ENGINE_RUN_ARGS+=(
        --userns=keep-id:uid=1000,gid=1000
        --security-opt label=type:container_engine_t
        --security-opt "unmask=/proc/*"
    )
else
    ENGINE_RUN_ARGS+=(
        --security-opt seccomp=unconfined
        --security-opt systempaths=unconfined
    )
fi

if ! "$ENGINE" image inspect "${CONTAINER}:latest" &>/dev/null; then
    echo "Image not found — run ./build.sh first."
    exit 1
fi
if "$ENGINE" ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Attaching to running container..."
    if [[ -n "$NO_TMUX" ]]; then
        "$ENGINE" exec -it "$CONTAINER" /bin/zsh
    else
        "$ENGINE" exec -it "$CONTAINER" /bin/zsh -c "tmux -u new-session -A -s main"
    fi
    exit 0
fi
if "$ENGINE" ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    "$ENGINE" rm "$CONTAINER"
fi
# Governance policy: a root-owned host dir, mounted READ-ONLY (see MOUNTS below).
# Must NOT be the rw-mounted dotfiles, or the agent could edit it from inside.
# Populate once on the host:
#   sudo mkdir -p /srv/agent-policy
#   sudo cp -rL ~/workspace/dotfiles/claude/settings.json \
#               ~/workspace/dotfiles/claude/policy-limits.json \
#               ~/workspace/dotfiles/claude/hooks /srv/agent-policy/
#   sudo chown -R root:root /srv/agent-policy
AGENT_POLICY="${AGENT_POLICY:-/Users/fabrizioperria/.claude/agent-policy}"
for f in settings.json policy-limits.json hooks; do
    [[ -e "$AGENT_POLICY/$f" ]] || { echo "Missing agent policy: $AGENT_POLICY/$f (see container_run.sh header)." >&2; exit 1; }
done

MOUNTS=()
for path in "$@"; do
    abs=$(cd "$path" 2>/dev/null && pwd || echo "$path")
    name=$(basename "$abs")
    MOUNTS+=(-v "${abs}:/workspaces/${name}")
done
touch .claude.json
[[ ! -f "${HOME}/.zsh_history_devenv" ]] && touch "${HOME}/.zsh_history_devenv"
MOUNTS+=(
    -v "nvim-data:/home/dev/.local/share/nvim"
    -v "claude-data:/home/dev/.claude"
    -v "${AGENT_POLICY}/settings.json:/home/dev/.claude/settings.json:ro"
    -v "${AGENT_POLICY}/policy-limits.json:/home/dev/.claude/policy-limits.json:ro"
    -v "${AGENT_POLICY}/hooks:/home/dev/.claude/hooks:ro"
    -v "${HOME}/.claude.json:/home/dev/.claude.json"
    -v "${HOME}/.zsh_history_devenv:/home/dev/.zsh_history"
    -v "${HOME}/Downloads/lsp:/workspaces/lsp"
    -v "${HOME}/.ssh_container:/home/dev/.ssh"
    -v "${HOME}/workspace/chords:/workspaces/chords"
    -v "${HOME}/workspace/dotfiles:/workspaces/dotfiles"
)

# Persist the nested podman image/container store across the --rm devenv.
# :U (podman-only) chowns the volume to the mapped user so rootless writes work
# under keep-id; docker initialises ownership from the image dir via copy-up.
if [[ "$ENGINE" == "podman" ]]; then
    MOUNTS+=(-v "podman-storage:/home/dev/.local/share/containers:U")
else
    MOUNTS+=(-v "podman-storage:/home/dev/.local/share/containers")
fi

ENV_FILE="${HOME}/.devenv.env"
ENV_ARGS=()
[[ -f "$ENV_FILE" ]] && ENV_ARGS+=(--env-file "$ENV_FILE")
ENTRYPOINT_ARGS=()
[[ -n "$NO_TMUX" ]] && ENTRYPOINT_ARGS+=(--entrypoint /bin/zsh)
"$ENGINE" run -it \
    --name "$CONTAINER" \
    --hostname devenv \
    -p80:5173 \
    "${ENGINE_RUN_ARGS[@]}" \
    "${ENTRYPOINT_ARGS[@]}" \
    "${ENV_ARGS[@]}" \
    "${MOUNTS[@]}" \
    "${CONTAINER}:latest"


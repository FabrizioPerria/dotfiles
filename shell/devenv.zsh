# Launch / attach the devenv container from anywhere.
#
# Sourced as a function (not run as a script), so it executes in the current
# shell. That forces three differences from the old container_run.sh:
#   - `return`, never `exit` (exit would kill your interactive shell)
#   - `local` vars (so it doesn't leak ENGINE/MOUNTS/... into your shell)
#   - `emulate -L zsh` (clean, localized options; restored on return)
# Behaviour is otherwise identical to container_run.sh.
#
# Usage:
#   devenv [DIR ...]            # each DIR -> bind-mounted at /workspaces/<name>
#   NO_TMUX=1 devenv            # drop straight into zsh, no tmux
#   CONTAINER_ENGINE=podman devenv
devenv() {
    emulate -L zsh

    local CONTAINER="devenv"
    local NO_TMUX="${NO_TMUX:-}"
    if [[ -n "${TMUX:-}" ]]; then
        NO_TMUX=1
    fi

    # Pick container engine: explicit override, else docker, else podman.
    local ENGINE="${CONTAINER_ENGINE:-}"
    if [[ -z "$ENGINE" ]]; then
        if command -v docker &>/dev/null; then
            ENGINE="docker"
        elif command -v podman &>/dev/null; then
            ENGINE="podman"
        else
            echo "Neither docker nor podman is installed." >&2
            return 1
        fi
    fi

    # Flags so nested podman works inside the devenv regardless of the outer engine.
    #   - both:   /dev/fuse, for the inner podman's fuse-overlayfs storage driver
    #   - podman: keep SELinux enforcing (container_engine_t) and map the host user
    #             to the container's dev (uid 1000) via keep-id so bind mounts stay
    #             writable (both podman-only)
    #   - docker: relax seccomp, since Docker's default profile blocks the
    #             namespace/clone syscalls rootless podman needs in order to nest
    local -a ENGINE_RUN_ARGS=(--device /dev/fuse --device /dev/net/tun)
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
        echo "Image not found — build it first (make build_docker)." >&2
        return 1
    fi

    if [[ -n "${TMUX:-}" ]] && [[ $NO_TMUX ]]; then
        tmux set-option -p -t "$TMUX_PANE" @devenv 1
        trap 'tmux set-option -pu -t "$TMUX_PANE" @devenv' EXIT
    fi

    if "$ENGINE" ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
        echo "Attaching to running container..."
        if [[ -n "$NO_TMUX" ]]; then
            "$ENGINE" exec -it "$CONTAINER" /bin/zsh
        else
            "$ENGINE" exec -it "$CONTAINER" /bin/zsh -c "tmux -u new-session -A -s main"
        fi
        return 0
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
    local AGENT_POLICY="${AGENT_POLICY:-/Users/fabrizioperria/.claude/agent-policy}"
    local f
    for f in settings.json policy-limits.json hooks; do
        [[ -e "$AGENT_POLICY/$f" ]] || { echo "Missing agent policy: $AGENT_POLICY/$f (see devenv.zsh header)." >&2; return 1; }
    done

    local -a MOUNTS=()
    local dir abs name
    for dir in "$@"; do
        abs=$(cd "$dir" 2>/dev/null && pwd || echo "$dir")
        name=$(basename "$abs")
        MOUNTS+=(-v "${abs}:/workspaces/${name}")
    done
    touch "${HOME}/.claude.json"
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

    local ENV_FILE="${HOME}/.devenv.env"
    local -a ENV_ARGS=()
    [[ -f "$ENV_FILE" ]] && ENV_ARGS+=(--env-file "$ENV_FILE")

    # Egress firewall. Start as root with the network capabilities so the image
    # entrypoint (devenv-entry) can lock egress to the allowlist, then it drops
    # to the unprivileged dev user. NO_TMUX passes /bin/zsh as the command, so
    # the entrypoint hands you a shell instead of the tmux session.
    # (NET_ADMIN/NET_RAW are runtime-only — they can't be baked into the image.)
    local -a FW_ARGS=(--user root --cap-add=NET_ADMIN --cap-add=NET_RAW)
    local -a CMD_ARGS=()
    [[ -n "$NO_TMUX" ]] && CMD_ARGS=(/bin/zsh)

    "$ENGINE" run -it \
        --name "$CONTAINER" \
        --hostname devenv \
        -p80:5173 \
        "${FW_ARGS[@]}" \
        "${ENGINE_RUN_ARGS[@]}" \
        "${ENV_ARGS[@]}" \
        "${MOUNTS[@]}" \
        "${CONTAINER}:latest" \
        "${CMD_ARGS[@]}"
}

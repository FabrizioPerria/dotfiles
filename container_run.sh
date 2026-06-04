#!/usr/bin/env bash
set -euo pipefail
CONTAINER="devenv"

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

# Rootless podman: map the host user to the container's dev (uid 1000) so bind
# mounts stay writable. keep-id is podman-only; rootful docker maps uid 1000
# directly, so it needs nothing here.
ENGINE_RUN_ARGS=()
if [[ "$ENGINE" == "podman" ]]; then
    ENGINE_RUN_ARGS+=(--userns=keep-id:uid=1000,gid=1000)
fi

if ! "$ENGINE" image inspect "${CONTAINER}:latest" &>/dev/null; then
    echo "Image not found — run ./build.sh first."
    exit 1
fi
if "$ENGINE" ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Attaching to running container..."
    "$ENGINE" exec -it "$CONTAINER" /bin/zsh -c "tmux -u new-session -A -s main"
    exit 0
fi
if "$ENGINE" ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    "$ENGINE" rm "$CONTAINER"
fi
MOUNTS=()
for path in "$@"; do
    abs=$(cd "$path" 2>/dev/null && pwd || echo "$path")
    name=$(basename "$abs")
    MOUNTS+=(-v "${abs}:/workspaces/${name}")
done
touch .claude.json
MOUNTS+=(
    -v nvim-data:/home/dev/.local/share/nvim
    -v "claude-data:/home/dev/.claude"
    -v "${HOME}/.claude.json:/home/dev/.claude.json"
    -v "${HOME}/.zsh_history_devenv:/home/dev/.zsh_history"
    -v "${HOME}/Downloads/lsp:/workspaces/lsp"
    -v "${HOME}/.ssh_container:/home/dev/.ssh"
)
ENV_FILE="${HOME}/.devenv.env"
ENV_ARGS=()
[[ -f "$ENV_FILE" ]] && ENV_ARGS+=(--env-file "$ENV_FILE")
"$ENGINE" run -it \
    --name "$CONTAINER" \
    --hostname devenv \
    "${ENGINE_RUN_ARGS[@]}" \
    "${ENV_ARGS[@]}" \
    "${MOUNTS[@]}" \
    "${CONTAINER}:latest"

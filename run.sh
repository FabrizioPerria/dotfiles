#!/usr/bin/env bash
# run.sh — launch (or reattach to) the dev container
#
# Usage:
#   ./run.sh [path1] [path2] ...

set -euo pipefail

CONTAINER="devenv"

if ! docker image inspect "${CONTAINER}:latest" &>/dev/null; then
    echo "Image not found — run ./build.sh first."
    exit 1
fi

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Attaching to running container..."
    docker exec -it "$CONTAINER" /bin/zsh -c "tmux -u new-session -A -s main"
    exit 0
fi

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    docker rm "$CONTAINER"
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
    -v claude:/home/dev/.claude
    -v .claude.json:/home/dev/.claude.json
)

docker run -it \
    --name "$CONTAINER" \
    --hostname devenv \
    "${MOUNTS[@]}" \
    "${CONTAINER}:latest"

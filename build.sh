#!/usr/bin/env bash

set -euo pipefail

CONTAINER="devenv"
CLEAN=false
[[ "${2:-}" == "--clean" ]] && CLEAN=true

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Removing container ${CONTAINER}..."
    docker rm -f "$CONTAINER"
fi

if $CLEAN; then
    echo "Wiping named volumes..."
    docker volume rm -f nvim-data claude || true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build \
    --tag "${CONTAINER}:latest" \
    "$SCRIPT_DIR"

echo "Done."

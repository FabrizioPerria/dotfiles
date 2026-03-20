#!/usr/bin/env bash
# rebuild.sh — stop the running container and trigger a fresh build+push
#
# Usage:
#   ./rebuild.sh <dockerhub-username>
#   ./rebuild.sh <dockerhub-username> --clean   # also wipe named volumes

set -euo pipefail

DOCKER_USER="fabrizioperria"
CONTAINER="devenv"
CLEAN=false
[[ "${2:-}" == "--clean" ]] && CLEAN=true

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Removing container ${CONTAINER}..."
    docker rm -f "$CONTAINER"
fi

if $CLEAN; then
    echo "Wiping named volumes..."
    docker volume rm -f nvim-data claude-cfg || true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/build-push.sh" "$DOCKER_USER"

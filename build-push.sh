#!/usr/bin/env bash
# build.sh — build the dev image locally for the current machine's arch
#
# Usage:
#   ./build.sh
#   ./build.sh --no-cache

set -euo pipefail

IMAGE="devenv:latest"
NO_CACHE=""
[[ "${1:-}" == "--no-cache" ]] && NO_CACHE="--no-cache"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build \
    $NO_CACHE \
    --tag "$IMAGE" \
    "$SCRIPT_DIR"

echo "Done."

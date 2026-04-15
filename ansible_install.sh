#!/bin/bash

set -e

SKIP_INSTALL=false

# Use sudo only if not already root
maybe_sudo() {
    if [ "$EUID" -ne 0 ]; then
        sudo "$@"
    else
        "$@"
    fi
}

# Parse arguments
for arg in "$@"; do
    case $arg in
    --skip-install)
        SKIP_INSTALL=true
        shift
        ;;
    esac
done

if [ "$SKIP_INSTALL" = false ]; then
    if [[ $(uname) == "Darwin" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install ansible
    elif command -v apt >/dev/null; then
        maybe_sudo apt update
        maybe_sudo apt install -y ansible
    fi
fi

ansible-playbook ansible/playbook.yml --ask-become-pass

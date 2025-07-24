#!/bin/bash

set -e

SKIP_INSTALL=false

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
        sudo apt update
        sudo apt install -y ansible
    fi
fi

ansible-playbook ansible/playbook.yml --ask-become-pass


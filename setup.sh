#!/bin/bash

set -e

if [[ $(uname) == "Darwin" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install ansible
elif command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y ansible
fi

ansible-playbook ansible/playbook.yml --ask-become-pass

gpg --full-generate-key

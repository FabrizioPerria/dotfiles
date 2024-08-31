#!/bin/bash

set -e

extra_cmd=""
if [[ $(uname) == "Darwin" ]]; then
    brew install --force python3 tmux neovim fzf ripgrep fd llvm jq git-lfs exa ncdu bottom cmake unzip thefuck bat node wget
elif command -v apt >/dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
    if [[ ! -d ${HOME}/.local/bin ]]; then
        mkdir -p "${HOME}"/.local/bin
    fi
    if [[ -L ${HOME}/.local/bin/bat ]]; then
        rm "${HOME}"/.local/bin/bat
    fi
    if [[ -L ${HOME}/.local/bin/fd ]]; then
        rm "${HOME}"/.local/bin/fd
    fi
    ln -s /usr/bin/fdfind "${HOME}"/.local/bin/fd
    ln -s /usr/bin/batcat "${HOME}"/.local/bin/bat

    pip3 install debugpy
    sudo locale-gen en_US.UTF-8
fi

rm -rf "${HOME}"/.oh-my-zsh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/wfxr/forgit.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/forgit
git clone --depth=1 https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/autoswitch_virtualenv

if [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
    git clone --depth=1 https://github.com/RitchieS/zsh-exa.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-exa
elif command -v apt >/dev/null; then
    git clone --depth=1 https://github.com/ptavares/zsh-exa.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-exa
fi

rm -rf "${HOME}"/.tmux
git clone https://github.com/tmux-plugins/tpm "${HOME}"/.tmux/plugins/tpm

echo "$extra_cmd" >"${HOME}"/.zshrc
echo "source ${HOME}/.config/shell/aliases.zsh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/shell/exports.zsh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/shell/zsh.zsh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/shell/p10k.zsh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/shell/colors.zsh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/fzf/completion.sh" >>"${HOME}"/.zshrc
echo "source ${HOME}/.config/fzf/keybindings.sh" >>"${HOME}"/.zshrc

rm -rf "${HOME}"/.config
mkdir "${HOME}"/.config

mkdir "${HOME}"/.config/fzf
cp -r fzf/* "${HOME}"/.config/fzf
mkdir "${HOME}"/.config/nvim
cp -r nvim/* "${HOME}"/.config/nvim
mkdir "${HOME}"/.config/shell
cp -r shell/* "${HOME}"/.config/shell
mkdir "${HOME}"/.config/tmux
cp -r tmux/* "${HOME}"/.config/tmux

~/.tmux/plugins/tpm/scripts/install_plugins.sh

rm -rf ~/.cache/nvim
nvim --headless +qa
nvim --headless +TSUpdateSync +MasonToolsInstallSync +qa

echo "DONE."

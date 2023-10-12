#!/bin/bash

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


mv -r ${HOME}/.config ${HOME}/.config.backup
mv ${HOME}/.zshrc ${HOME}/.zshrc.bak
mkdir .config

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew install iterm2 tmux neovim fzf ripgrep fd llvm jq git-lfs

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo 'source ${HOME}/.config/shell/aliases.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/exports.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/zsh.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/p10k.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/completion.sh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/keybindings.sh'>> ${HOME}/.zshrc

cp -r ./fzf ${HOME}/.config/fzf
cp -r ./shell ${HOME}/.config/shell
cp -r ./nvim ${HOME}/.config/nvim
cp -r ./tmux ${HOME}/.config/tmux

source "${HOME}"/.zshrc




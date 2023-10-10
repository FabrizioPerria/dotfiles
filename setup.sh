#!/bin/bash

set -e

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

mv -r ${HOME}/.config ${HOME}/.config.backup
mv ${HOME}/.zshrc ${HOME}/.zshrc.bak
mkdir .config

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew install iterm2 fzf jq ripgrep git-lfs powerlevel10k

echo 'source ${HOME}/.config/shell/aliases.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/exports.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/zsh.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/p10k.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/completion.sh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/keybindings.sh'>> ${HOME}/.zshrc

cp -r . ${HOME}/.config

source ${HOME}/.zshrc


#!/bin/bash

set -e

if [[ -d ${HOME}/.config ]]; then
	rm -rf ${HOME}/.config.backup
	mv ${HOME}/.config ${HOME}/.config.backup
	mkdir ${HOME}/.config
fi

if [[ -f ${HOME}/.zshrc ]]; then 
	mv ${HOME}/.zshrc ${HOME}/.zshrc.bak
fi

if [[ $(uname) == "Darwin" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install iterm2 python3 python3-pip python3-venv tmux neovim fzf ripgrep fd llvm jq git-lfs exa ncdu bottom cmake unzip thefuck
elif command -v apt > /dev/null; then
    sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update
	sudo apt install -y zsh python3 python3-venv python3-pip unzip cmake tmux neovim fzf ripgrep fd-find llvm jq git-lfs exa ncdu thefuck
	curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
	sudo dpkg -i bottom_0.9.6_amd64.deb
	chsh -s $(which zsh)
	if [[ ! -d ${HOME}/.local/bin ]]; then
		mkdir -p ${HOME}/.local/bin
	fi
	if [[ -L ${HOME}/.local/bin/fd ]]; then
		rm ${HOME}/.local/bin/fd
	fi
	ln -s /usr/bin/fdfind ${HOME}/.local/bin/fd
fi

rm -rf ${HOME}/.oh-my-zsh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/ptavares/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa
rm -rf ${HOME}/.tmux
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

rm -rf  ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim

echo 'source ${HOME}/.config/shell/aliases.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/exports.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/zsh.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/p10k.zsh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/completion.sh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/keybindings.sh'>> ${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/colors.sh'>> ${HOME}/.zshrc

cp -r ./fzf ${HOME}/.config
cp -r ./shell ${HOME}/.config
cp -r ./nvim ${HOME}/.config
cp -r ./tmux ${HOME}/.config

#zsh
#source "${HOME}"/.zshrc


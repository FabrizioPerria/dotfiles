#!/bin/bash

set -e

if [[ -d ${HOME}/.config ]]; then
	rm -rf ${HOME}/.config.backup
	mv ${HOME}/.config ${HOME}/.config.backup
fi

if [[ -f ${HOME}/.zshrc ]]; then
	mv ${HOME}/.zshrc ${HOME}/.zshrc.bak
fi

extra_cmd=""
if [[ $(uname) == "Darwin" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval $(/opt/homebrew/bin/brew shellenv)
	if [[ ! -d /Applications/iTerm.app ]]; then
		brew install --cask iterm2
	fi
	brew install --force python3 tmux neovim fzf ripgrep fd llvm jq git-lfs exa ncdu bottom cmake unzip thefuck bat node wget
	extra_cmd='eval $(/opt/homebrew/bin/brew shellenv)'
elif command -v apt >/dev/null; then
	sudo apt update
	sudo apt install -y software-properties-common apt-transport-https wget curl locales
	sudo add-apt-repository ppa:neovim-ppa/unstable
	curl -fsSL https://deb.nodesource.com/setup_21.x | bash 
	sudo apt update
	sudo apt install -y nodejs zsh git tmux neovim sudo wget python3-neovim python3-dev python3-pip python3-venv fontconfig unzip ripgrep fd-find bat exa htop ncdu tree clang cmake build-essential jq git-lfs axel sshfs clangd

	chsh -s $(which zsh)
	curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
	sudo dpkg -i bottom_0.9.6_amd64.deb

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
	if [[ ! -d ${HOME}/.local/bin ]]; then
		mkdir -p ${HOME}/.local/bin
	fi
	if [[ -L ${HOME}/.local/bin/bat ]]; then
		rm ${HOME}/.local/bin/bat
	fi
	if [[ -L ${HOME}/.local/bin/fd ]]; then
		rm ${HOME}/.local/bin/fd
	fi
	ln -s /usr/bin/fdfind ${HOME}/.local/bin/fd
	ln -s /usr/bin/batcat ${HOME}/.local/bin/bat
	
	pip3 install debugpy
	sudo locale-gen en_US.UTF-8
fi

rm -rf ${HOME}/.oh-my-zsh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit

if [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then \
	git clone --depth=1 https://github.com/RitchieS/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa; \
elif command -v apt >/dev/null; then \
	git clone --depth=1 https://github.com/ptavares/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa; \
fi;

rm -rf ${HOME}/.tmux
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

echo $extra_cmd >${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/aliases.zsh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/exports.zsh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/zsh.zsh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/p10k.zsh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/completion.sh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/fzf/keybindings.sh' >>${HOME}/.zshrc
echo 'source ${HOME}/.config/shell/colors.zsh' >>${HOME}/.zshrc

mkdir ${HOME}/.config

mkdir ${HOME}/.config/fzf
cp -r fzf/* ${HOME}/.config/fzf
mkdir ${HOME}/.config/nvim
cp -r nvim/* ${HOME}/.config/nvim
mkdir ${HOME}/.config/shell
cp -r shell/* ${HOME}/.config/shell
mkdir ${HOME}/.config/tmux
cp -r tmux/* ${HOME}/.config/tmux

~/.tmux/plugins/tpm/scripts/install_plugins.sh

rm -rf ~/.cache/nvim
nvim --headless +qa
nvim --headless +TSUpdateSync +MasonToolsInstallSync +qa

echo "DONE."

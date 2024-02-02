#!/bin/bash

set -e

if [[ -d ${HOME}/.config ]]; then
	rm -rf ${HOME}/.config.backup
	mv ${HOME}/.config ${HOME}/.config.backup
fi

if [[ -f ${HOME}/.zshrc ]]; then
	mv ${HOME}/.zshrc ${HOME}/.zshrc.bak
fi

extra_cmd=""-
if [[ $(uname) == "Darwin" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval $(/opt/homebrew/bin/brew shellenv)
	if [[ ! -d /Applications/iTerm.app ]]; then
		brew install --cask iterm2
	fi
	brew install --force python3 tmux neovim fzf ripgrep fd llvm jq git-lfs exa ncdu bottom cmake unzip thefuck bat node wget
	extra_cmd='eval $(/opt/homebrew/bin/brew shellenv)'
elif command -v apt >/dev/null; then
	sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update
	sudo apt install -y zsh python3 python3-venv python3-pip python3-neovim unzip cmake tmux neovim ripgrep fd-find llvm jq git-lfs exa ncdu thefuck wget bat
	chsh -s $(which zsh)
	curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb
	sudo dpkg -i bottom_0.9.6_amd64.deb
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	extra_cmd='export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
	export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	nvm install --lts
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
fi

rm -rf ${HOME}/.oh-my-zsh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/forgit

if [[ $(uname) == "Darwin" ]]; then
	git clone --depth=1 https://github.com/RitchieS/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa
elif command -v apt >/dev/null; then
	git clone --depth=1 https://github.com/ptavares/zsh-exa.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-exa
fi

rm -rf ${HOME}/.tmux
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

rm -rf ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth=1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim

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

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Meslo.zip
echo "Now you can install Meslo fonts, reopen your terminal and run nvim +PackerSync to install plugins"

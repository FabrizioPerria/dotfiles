# Load and optimize compinit
autoload -Uz compinit

zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f "$zcompdump" ]]; then
    compinit
else
    compinit -d "$zcompdump"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_UNICODE=1

zstyle ':omz:plugins:nvm' autoload yes

plugins=( git zsh-syntax-highlighting zsh-autosuggestions fzf web-search sudo forgit autoswitch_virtualenv )
if [ "$(uname)" = "Darwin" ]; then
    bindkey -M emacs '^\e' sudo-command-line
    bindkey -M vicmd '^\e' sudo-command-line
    bindkey -M viins '^\e' sudo-command-line
fi
source $ZSH/oh-my-zsh.sh


autoload -Uz compinit

# Define zcompdump location
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

# Enable async loading of completion system
{
    # Only regenerate completion dump if it's older than 24 hours
    if [[ -f "$zcompdump"(#qN.mh+24) ]]; then
        compinit -d "$zcompdump"
    else
        # Use cached completion dump
        compinit -C -d "$zcompdump"
    fi

    # Compile zcompdump if modified
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
} &!

# Load the faster complist module
zmodload -i zsh/complist

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_UNICODE=1
BENCHMARK=1

plugins=( git zsh-syntax-highlighting zsh-autosuggestions fzf autoswitch_virtualenv )

source $ZSH/oh-my-zsh.sh
unset BENCHMARK


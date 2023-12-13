export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_TMUX_UNICODE=1

plugins=( git zsh-syntax-highlighting zsh-autosuggestions fzf web-search thefuck sudo ripgrep zsh-exa forgit)
if [ "$(uname)" = "Darwin" ]; then
  bindkey -M emacs '^\e' sudo-command-line
  bindkey -M vicmd '^\e' sudo-command-line
  bindkey -M viins '^\e' sudo-command-line
fi
source $ZSH/oh-my-zsh.sh

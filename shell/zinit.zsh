source ${HOME}/.zinit/bin/zinit.zsh

# Ensure completion system is initialized lazily
skip_global_compinit=1

zinit wait lucid atload"zicompinit; zicdreplay" for zsh-users/zsh-completions
zmodload -i zsh/complist

zinit wait lucid for "junegunn/fzf"

zinit wait lucid for "fabrizioperria/zsh-venv-autoswitch"
zinit wait lucid for "zsh-users/zsh-syntax-highlighting"
zinit wait lucid for "zsh-users/zsh-autosuggestions"
zinit wait lucid for "zsh-users/zsh-history-substring-search"

zinit light "romkatv/powerlevel10k"

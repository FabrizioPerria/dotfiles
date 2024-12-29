source ${HOME}/.zinit/bin/zinit.zsh

# Ensure completion system is initialized lazily
skip_global_compinit=1

zinit ice depth"1"
zinit wait lucid atload"zicompinit; zicdreplay" for zsh-users/zsh-completions
zmodload -i zsh/complist

zinit wait lucid as=program \
    atclone="PREFIX=$ZPFX FZF_VERSION=0.54.0 FZF_REVISION=1 make install &&
      mkdir -p $ZPFX/{bin,man/man1} &&
      cp shell/completion.zsh _fzf_completion &&
      cp -vf bin/fzf(|-tmux) $ZPFX/bin &&
      cp -vf man/man1/fzf(|-tmux).1 $ZPFX/man/man1" \
    depth=1 \
    for junegunn/fzf

zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh

zinit ice depth"1" && zinit wait lucid for "fabrizioperria/zsh-venv-autoswitch"
zinit ice depth"1" && zinit wait lucid for "zsh-users/zsh-syntax-highlighting"
zinit ice depth"1" && zinit wait lucid for "zsh-users/zsh-autosuggestions"
zinit ice depth"1" && zinit wait lucid for "zsh-users/zsh-history-substring-search"
zinit ice depth"1" && zinit light "romkatv/powerlevel10k"

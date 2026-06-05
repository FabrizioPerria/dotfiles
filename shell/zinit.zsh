source ${HOME}/.zinit/bin/zinit.zsh

# Ensure completion system is initialized lazily
skip_global_compinit=1

if [[ "$OSTYPE" == darwin* || ! -f "${ZDOTDIR:-$HOME}/.setup-completions" ]]; then
    zinit wait lucid atload"zicompinit; zicdreplay" depth=1 for "zsh-users/zsh-completions"
    touch "${ZDOTDIR:-$HOME}/.setup-completions"
fi

zmodload -i zsh/complist

zinit wait lucid as=program \
    atclone="PREFIX=$ZPFX FZF_VERSION=0.54.0 FZF_REVISION=1 make install &&
      mkdir -p $ZPFX/{bin,man/man1} &&
      cp shell/completion.zsh _fzf_completion &&
      cp -vf bin/fzf(|-tmux) $ZPFX/bin &&
      cp -vf man/man1/fzf(|-tmux).1 $ZPFX/man/man1" \
    depth=1 \
    atload"source <(fzf --zsh)" \
    for junegunn/fzf

zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/key-bindings.zsh
zinit snippet https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh

zinit wait lucid depth=1 ver"5c4f2ef" for "Aloxaf/fzf-tab"
zinit wait lucid depth=1 for "fabrizioperria/zsh-venv-autoswitch"
zinit wait lucid depth=1 for "zsh-users/zsh-history-substring-search"
zinit wait lucid depth=1 ver"v1.2.0" for "zsh-users/zsh-autosuggestions"
zinit wait lucid depth=1 ver"v0.8.0" for "zsh-users/zsh-syntax-highlighting"
zinit wait lucid depth=1 ver"v0.9.0" for "zsh-users/zsh-history-substring-search"
zinit ice depth"1" ver"v5.0.0" && zinit light "romkatv/powerlevel10k"
zinit wait lucid depth=1 for "zsh-users/zsh-completions"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompdump

_zoxide_z_complete_frecent() {
  # 1. real cd completion first — identical to `cd`, fzf popup and all
  _cd && return

  # 2. only if nothing completed as a path → zoxide frecent dirs
  local query="${words[2,-1]}"
  local -a frecent
  frecent=("${(@f)$(zoxide query --list -- ${=query} 2>/dev/null)}")
  (( ${#frecent} )) && compadd -U -a frecent
}

zinit ice wait lucid id-as="zoxide-init" \
    atload'eval "$(zoxide init zsh)"; compdef _zoxide_z_complete_frecent z'
zinit light zdharma-continuum/null


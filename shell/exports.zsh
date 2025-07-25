bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

export ZSH="$HOME/.oh-my-zsh"
export ZSH_DISABLE_COMPFIX=true
export DISABLE_AUTO_UPDATE=true
export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv"
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git --exclude node_modules --exclude .venv"

export JAVA_HOME="<JAVA_HOME_PATH>"
export PATH="$JAVA_HOME/bin:$HOME/.zinit/bin:/usr/local/go/bin:$HOME/.fnm:/opt/homebrew/bin:$HOME/.local/bin:/opt/homebrew/opt/gawk/libexec/gnubin:/opt/homebrew/opt/llvm/bin:$PATH:/opt/local/bin:$HOME/.cargo/bin"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

export GPG_TTY=$(tty)

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

export CC=/usr/bin/cc
export CXX=/usr/bin/c++

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY

export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export ZSH_THEME="powerlevel10k/powerlevel10k"
export ZSH_TMUX_UNICODE=1

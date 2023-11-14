export FZF_DEFAULT_COMMAND="fd --type f --hidden"
export FZF_DEFAULT_OPTS="--preview 'bat --color=always {}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export PATH="$HOME/.local/bin:/opt/homebrew/opt/gawk/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

export GPG_TTY=$(tty)

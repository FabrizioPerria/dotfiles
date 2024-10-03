alias ls=exa
alias vi=nvim
alias vim=nvim
alias tmux="tmux -u a || tmux -u "
alias mon="btm"
alias rf='f(){ rg --hidden -l "$1" . | fzf | xargs nvim; }; f'
alias gittree="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias xcopy="xclip -selection clipboard"

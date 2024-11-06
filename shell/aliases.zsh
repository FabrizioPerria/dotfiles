alias ls='exa $eza_params'
alias l='exa --git-ignore $eza_params'
alias ll='exa --all --header --long $eza_params'
alias llm='exa --all --header --long --sort=modified $eza_params'
alias la='exa -lbhHigUmuSa'
alias lx='exa -lbhHigUmuSa@'
alias lt='exa --tree $eza_params'
alias tree='exa --tree $eza_params'

alias vi=nvim
alias vim=nvim
alias tmux="tmux -u a || tmux -u "
alias mon="btm"
alias rf='f(){ rg --hidden -l "$1" . | fzf | xargs nvim; }; f'
alias gittree="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias xcopy="xclip -selection clipboard"
alias login-db="az account get-access-token --resource-type oss-rdbms --output tsv --query accessToken"

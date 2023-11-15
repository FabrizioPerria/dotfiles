export LS_COLORS='fi=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:'
LS_COLORS+='pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32'

# This is optional. Try `ls -l` with and without it and see which one you like better.
LS_COLORS+=':no=38;5;248'

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

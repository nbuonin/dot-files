export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

function parse_git_branch { 
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
} 
export PS1="\u@\h:\w \$(parse_git_branch) \\$ "
alias ll="ls -lhA"

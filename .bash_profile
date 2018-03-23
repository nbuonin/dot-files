#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export PATH="~/Library/Python/3.6/bin:$PATH"
export PIPENV_VENV_IN_PROJECT=true
# Per brew info python
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/python@2/libexec/bin:/usr/local/opt/python@2/bin:$PATH"

# Go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$(go env GOPATH)

export CPPFLAGS="-I/usr/local/opt/openssl/include"
export LDFLAGS="-L/usr/local/opt/openssl/lib"

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export GUIDE_PATH="$HOME/guides"

function parse_git_branch { 
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
} 
export PS1="\u@\h:\w \$(parse_git_branch) \\$ "

# Updates the dot-files directory
git -C ~/dot-files pull origin master > /dev/null 2>&1

# Git autocompletion
source ~/dot-files/git-completion.bash
# Aliases
alias l="ls"
alias ll="ls -lhA"
alias ripit='cdparanoia -B && for i in *.wav; do ffmpeg -i "$i" "${i%.cdda.wav}".flac ; done'
alias wav2flac='for i in *.wav; do ffmpeg -i "$i" "${i%.cdda.wav}".flac ; done'
alias cpr="cp -r"
alias rmr="rm -rf"
alias o="open"
alias e="vim"
alias eb="vim ~/dot-files/.bash_profile"
alias eg="vim ~/dot-files/.gitconfig"
alias ev="vim ~/dot-files/.vimrc"
alias sb="source ~/.bash_profile && echo 'Bash Profile Sourced'"
## see .gitconfig for alias
alias gpo="git po"
## spider site with wget to check for broken links
function link-check {
    wget --spider -r -nd -nv -l ${2-3} --waitretry ${3-2} -o run1.log $1 && echo "view run1.log to see output"
}

# This opens a "guide" file that you've written. They are a way to keep technical notes.
function g {
    if [ -z $1 ]; then
        echo "Usage: g <name of guide>"
    fi

    if [ -f "$GUIDE_PATH/$1" ]; then
        view $GUIDE_PATH/$1
    else
        vim $GUIDE_PATH/$1
    fi
}
alias cdg="cd $GUIDE_PATH"

# Sets up Ruby so I'm not clobbering the system Ruby. First install rbenv with
# Homebrew, and follow rbenv instructions, per this SO: 
# https://stackoverflow.com/questions/36485180/how-to-update-ruby-with-homebrew
if [ $(rbenv > /dev/null 2>&1) ]; then eval "$(rbenv init -)"; fi

# OPAM configuration
. /Users/nickb/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval $(opam config env)

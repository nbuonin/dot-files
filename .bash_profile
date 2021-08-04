# Use vi editing mode
set -o vi
bind -m vi-insert "\C-l":clear-screen

export EDITOR=$(which vim)
# Pyenv setup
PATH=$(pyenv root)/shims:$PATH

#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export PATH="~/Library/Python/3.6/bin:$PATH"
export PIPENV_VENV_IN_PROJECT=true
# Per brew info python
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/python@2/libexec/bin:/usr/local/opt/python@2/bin:$PATH"

if [ `uname` == 'Darwin' ]; then
    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init -)"
    fi
    # Needed to get YouCompleteMe to build
    export PYTHON_CONFIGURE_OPTS="--enable-framework"
fi

# Haskell
export PATH=$PATH:~/.local/bin
export PATH=$(stack path --compiler-bin):$PATH

# Go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$(go env GOPATH)

export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# For zlib/Pillow
export LDFLAGS="-L/usr/local/opt/zlib/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/zlib/include $CPPFLAGS"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh"  ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion"  ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

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
alias mt="make test"
alias mr="make runserver"
alias eb="vim ~/dot-files/.bash_profile"
alias eg="vim ~/dot-files/.gitconfig"
alias ev="vim ~/dot-files/.vimrc"
alias sb="source ~/.bash_profile && echo 'Bash Profile Sourced'"
alias batt="pmset -g batt"
alias dnscc="dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias aws-auth="aws-mfa --duration 10800"
## see .gitconfig for alias
alias gpo="git po"
## spider site with wget to check for broken links
function link-check {
    if [ ! $1 ]; then
        echo "Usage: link-check <hostname> <level of links to follow> <timeout seconds>"
        echo "Default level: 3, Default timeout: 2s"
        return 0;
    fi
    wget --spider -r -nd -nv -l ${2-3} --waitretry ${3-2} -o run1.log $1
    echo "view run1.log to see output"
    less run1.log
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

# Create directory and change into it
function mdc {
    mkdir $1 && cd $1
}

# Watcher Script
function wit {
    if [ ! $2 ];
    then
        echo "Usage: wit <file or dir to watch> '<cmd to execute>' opt: time to sleep"
        return 0;
    fi;
    M_TIME=$(stat -f %c $1);
    while true
    do
        TEMP_TIME=$(stat -f %c $1);
        if [ "M_TIME" != "$TEMP_TIME" ];
        then
            $($2)
            M_TIME=$TEMP_TIME;
        fi;
        if [ $3 ]
        then
            sleep $3;
        else
            sleep 2;
        fi;
    done;
}

function rdb {
    if [ ! $2 ];
    then
        echo "rdb: rebuilds Postgres Database"
        echo "Usage: rdb <database name> <database file to import>"
        return 0;
    fi;
    dropdb $1 && createdb $1 && psql $1 < $2 
}

function runserver {
    python3 -m http.server
}

function pull-package {
    sed -i.bak "/$1.*/d" requirements.txt
    rm requirements.txt.bak
    make test
    if [ $? -eq 0 ];
    then
        git checkout -b remove-$1
        git add requirements.txt
        git commit -m "remove $1"
        git po
    fi;
}

function gifit {
    if [ ! $2 ];
    then
        echo "gifit: Turns a video into a gif using ffmpeg"
        echo "Usage: gifit <input movie> <gif file name, leave off extention>"
        return 0;
    fi;
    # Based on: https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
    ffmpeg -i $1 -vf "fps=15,scale=960:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 $2.gif
}

function rc {
    rustc $1.rs && ./$1 && rm $1
}

# Sets up Ruby so I'm not clobbering the system Ruby. First install rbenv with
# Homebrew, and follow rbenv instructions, per this SO: 
# https://stackoverflow.com/questions/36485180/how-to-update-ruby-with-homebrew
if [ $(which rbenv) ]; then eval "$(rbenv init -)"; fi

# OPAM configuration
. /Users/nickb/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
eval $(opam config env)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/Downloads/google-cloud-sdk/path.bash.inc' ]; then source '~/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/Downloads/google-cloud-sdk/completion.bash.inc' ]; then source '~/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# Fix clang
#export PATH="/usr/local/opt/llvm/bin:$PATH"
#export CC=clang
#export CXX=$(CC)++

#LDFLAGS += -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib
#CPPFLAGS += -I/usr/local/opt/llvm/include -I/usr/local/opt/llvm/include/c++/v1/



export PATH="$HOME/.cargo/bin:$PATH"

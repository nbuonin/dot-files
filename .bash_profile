export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

function parse_git_branch { 
   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' 
} 
export PS1="\u@\h:\w \$(parse_git_branch) \\$ "
alias ll="ls -lhA"
alias ripit='cdparanoia -B && for i in *.wav; do ffmpeg -i "$i" "${i%.cdda.wav}".flac ; done'
alias wav2flac='for i in *.wav; do ffmpeg -i "$i" "${i%.cdda.wav}".flac ; done'
# Sets up Ruby so I'm not clobbering the system Ruby. First install rbenv with
# Homebrew, and follow rbenv instructions, per this SO: 
# https://stackoverflow.com/questions/36485180/how-to-update-ruby-with-homebrew
if [ $(rbenv > /dev/null 2>&1) ]; then eval "$(rbenv init -)"; fi

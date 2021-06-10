# Changing/making/removing directory
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'

alias -g .2='../..'
alias -g .3='../../..'
alias -g .4='../../../..'
alias -g .5='../../../../..'
alias -g .6='../../../../../..'

alias -- -='cd -'
alias ~="cd ~"
alias b='cd ..'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

alias dt='cd ~/Desktop'
alias dev='cd ~/Developer'
alias dl="cd ~/Downloads"
alias repos="cd ~/Developer/GitRepos"

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d

# List directory contents
alias lsa='ls -lah'
alias l="ls -lFah ${colorflag}"
alias ll='ls -lh'
alias la='ls -lAh'
alias lsl="ls -l"
# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# manipulation
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Get current contents of PATH
alias path='echo -e ${PATH//:/\\n}'
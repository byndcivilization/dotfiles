autoload -Uz is-at-least

# make tmux work with alacritty
export TERM=xterm-256color

# *-magic is known buggy in some versions; disable if so
if [[ $DISABLE_MAGIC_FUNCTIONS != true ]]; then
  for d in $fpath; do
    if [[ -e "$d/url-quote-magic" ]]; then
      if is-at-least 5.1; then
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
      fi
      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic
    break
    fi
  done
fi

## jobs
setopt long_list_jobs

env_default 'PAGER' 'less'
env_default 'LESS' '-R'

## super user alias
alias _='sudo '

## more intelligent acking for ubuntu users
if (( $+commands[ack-grep] )); then
  alias afind='ack-grep -il'
else
  alias afind='ack -il'
fi

# recognize comments
setopt interactivecomments

# =================
# Util
# =================
alias update="sudo softwareupdate --install --all \
            && brew update \
            && brew upgrade --all \
            && brew cleanup \
            && npm install -g npm \
            && npm update -g \
            && sudo gem update --system \
            && sudo gem update"
alias garbage-dump="sudo rm -frv /Volumes/*/.Trashes; \
					sudo rm -frv ~/.Trash; \
                    sudo rm -frv /private/var/log/asl/*.asl; \
                    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias empty-trash='rm -rf ~/.Trash/*'
alias hide_desktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias show_desktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hide_files="defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder"
alias show_files="defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"
alias cleanupds="find . -type f -name '*.DS_Store' -ls -delete"
# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
alias n="nano"
alias h="history"
alias j="jobs"
alias v="vim"
alias s="subl ."
alias o="open"
alias oo="open ."
alias aliases="nano $HOME/dotfiles/config/misc.zsh \
			   && cp $HOME/dotfiles/config/misc.zsh $HOME/.oh-my-zsh/lib/misc.zsh \
			   && source $HOME/.oh-my-zsh/lib/misc.zsh"
# Get week number
alias week='date +%V'
# Become system administrator
alias god='sudo -i'
alias root='sudo -i'
# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"
# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"
# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"
# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"
# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"
# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# =================
# Networking
# =================
alias local-ip="ipconfig getifaddr en1"
alias clear-dns-cache="sudo dscacheutil -flushcache; \
                       sudo killall -HUP mDNSResponder"
alias ping1='ping -c 4 www.google.com'
alias ping2='ping -c 4 192.168.0.1'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias whois="whois -h whois-servers.net"
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "$method"="lwp-request -m '$method'"
done

# =================
# Homebrew
# =================
alias brewd="brew doctor"
alias brewi="brew install"
alias brewr="brew uninstall"
alias brews="brew search"
alias brewu="brew update \
                && brew upgrade --all \
                && brew cleanup \
                && brew cask cleanup"

# =================
# Shell
# =================
alias please="sudo"
alias :q="exit"
alias q="exit"
alias c="clear"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias m="man"
alias map="xargs -n1"
alias rm="rm -rf --"
alias edit-zash='sublime ~/.zshrc' # open zshrc in sublime
alias edit-bash='sublime ~/.bash_profile'
alias edit-tmux='sublime ~/.tmux/tmux.conf'
alias zfrash='source ~/.zshrc' # refresh zshrc
alias tfresh='tmux source-file ~/.tmux/tmux.conf'
alias refrash='source ~/.bash_profile'
alias falias='alias | grep ' # search all aliases (Jacob!)

# ====================
# Git Aliases
# ====================
alias g="git"
alias gclone="git clone"
alias gpush='git push origin master'
alias gpull='git pull origin master'
alias gstat='git status'
alias gitclean='git checkout master && git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
alias gd='git diff --color-words'
alias glog='git log --pretty=oneline --abbrev-commit'
alias glod='git log --graph --pretty="%Cgreen%h%Creset%Cblue%d%Creset %Cred%an%Creset: %s"'
alias gitl='git log --pretty=oneline'
alias lgl='git log --oneline --decorate'

# =================
# Node Aliases
# =================
alias kll='kill -9'
alias fpid3='lsof -i:3000'
alias fpid5='lsof -i:5858'
alias mls='lsof -Pi | grep LISTEN'
alias killport='function _killp(){ lsof -nti:$1 | xargs kill -9 };_killp'


# =================
# Spotify
# =================
alias sp="spotify play"
alias sps="spotify play && spotify status"
alias spa="spotify pause"
alias svu="spotify vol up"
alias svd="spotify vol down"
alias sv="spotify vol"
alias ss="spotify status"
alias sn="spotify next"
# alias schill="spotify play uri spotify:user:spotify:playlist:37i9dQZF1DWZeKCadgRdKQ"

# =================
# dotfiles Aliases
# =================
alias dotf='cd ~/dotfiles'
alias tdotf='vim ~/.tmux/tmux.conf'


# ====================
# Docker
# ====================
# Kill all running containers.
alias dockerkillall="docker kill $(docker ps -q)"
# Delete all stopped containers.
alias dockercleanc="printf '\n>>> Deleting stopped containers\n\n' && docker rm $(docker ps -a -q)"
# Delete all untagged images.
alias dockercleani="printf '\n>>> Deleting untagged images\n\n' && docker rmi $(docker images -q -f dangling=true)"
# Delete all stopped containers and untagged images.
alias dockerclean="dockercleanc || true && dockercleani"

# ====================
# Kubectl
# ====================
# set kube and gcloud
declare -x KUBE=$(which kubectl)
# Kubectl alias
alias kc="$KUBE"
# Get current Kubectl context
alias ctx="$KUBE config current-context"
# Set current Kubectl context
alias setctx="$KUBE config use-context"
# List all Kubectl contexts
alias lsctx="$KUBE config view | grep context: -A 5 | grep name:"

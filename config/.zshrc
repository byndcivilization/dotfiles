# zmodload zsh/zprof
# uncomment this to test zsh speed
# Path to your oh-my-zsh installation.
#timer=$(($(gdate +%s%N)/1000000))
export PATH=/opt/homebrew/bin:$PATH
export ZSH=$HOME/.oh-my-zsh

export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
export FZF_BASE="$HOME/.fzf"
ZSH_THEME="jonathan"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH="/usr/local/opt/openssl/bin:$PATH"
alias lzd='lazydocker'

eval "$(pyenv init -)"

ulimit -n 1024
ulimit -u 1024

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"
unset GOOS;
unset GOARCH;
export GOROOT=$HOME/.gimme/versions/go1.10.3.darwin.amd64;
export PATH=$HOME/.gimme/versions/go1.10.3.darwin.amd64/bin:${PATH};
go version >&2;

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export GIMME_ENV=$HOME/.gimme/envs/go1.10.3.env
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go && export PATH=$PATH:$GOPATH/bin

export PATH=$PATH:./_output/local/bin/darwin/amd64/kubectl

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export ANSIBLE_NOCOWS=1

# --- Plugins
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(sudo alias-tips zsh-autosuggestions osx zsh-syntax-highlighting)
# plugins=(sudo alias-tips osx zsh-syntax-highlighting)
plugins=(
    alias-finder
    ansible
    aws
    brew
    brew-cask
    colored-man-pages
    docker
    docker-compose
    gcloud
    git
    github
    git-prompt
    helm
    history
    httpie
    jsontools
    jira
    kubectl
    nmap
    npm
    nvm
    osx
    pip
    pyenv
    pylint
    python
    rails
    rake
    sublime
    tmux
    zsh-interactive-cd
)

# --- Customize it!
# Would you like to use another custom folder than $ZSH/custom?
# echo $ZSH_CUSTOM (shows where it is)
# ZSH_CUSTOM=$HOME/dotfiles/custom/themes/

export PATH=/opt/homebrew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/opt/mongodb-community@4.0/bin
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# add my local scripts
export PATH=$HOME/bin:$PATH

# add mysql to zshrc
export PATH=/usr/local/mysql/bin:$PATH

plugins=(vi-mode zsh-autosuggestions fzf)

# z - frecent (track where you last were)
#. $HOME/z.sh

# --- Source
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.functions

# vi-escape delays - https://www.johnhawthorn.com/2012/09/vi-escape-delays/
#export KEYTIMEOUT=1

# VI Mode
# navigate zsh tab completion
# zstyle ':completion:*' menu select
# zmodload zsh/complist

# use the vi navigation keys in menu completion
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history

#bindkey -v
#bindkey -M viins ‘jk’ vi-cmd-mode # jk takes you to cmd mode!
#bindkey '^P' up-history
#bindkey '^N' down-history
#bindkey '^?' backward-delete-char
#bindkey '^h' backward-delete-char
#bindkey '^w' backward-kill-word
#bindkey '^r' history-incremental-search-backward
#bindkey '`'  autosuggest-accept # If you want to accept and type out all of what autosuggest suggests just type `


prompt_dir() {
    prompt_segment blue black "%$(( $COLUMNS - 61 ))<...<%3~%<<"
}
if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
    _z_precmd() {
        (_z --add "${PWD:a}" &)
		: $RANDOM
    }
else
    _z_precmd() {
        (_z --add "${PWD:A}" &)
		: $RANDOM
    }
fi

autoload -Uz is-at-least
if [[ $ZSH_VERSION != 5.1.1 ]]; then
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

autoload -Uz compinit
# case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zprof # bottom of .zshrc for speed
export PATH="/usr/local/opt/node@12/bin:$PATH"
# Sublime Text can now use subl
export PATH=$PATH:/Applications/Sublime\ Text.app/Contents/SharedSupport/bin
# Makes green/red highlighting work
source  $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
eval "$(/usr/local/bin/brew shellenv)"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"

fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cperry/y/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/cperry/y/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cperry/y/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/cperry/y/google-cloud-sdk/completion.zsh.inc'; fi

# recognize comments
setopt interactivecomments


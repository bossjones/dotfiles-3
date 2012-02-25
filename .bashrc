################################################################################
# Global environment
################################################################################

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

################################################################################
# Setup misc
################################################################################

if [[ -d "$HOME/.scripts/lib" ]]; then
  source "$HOME/.scripts/lib/"*
fi

p() {
  if [[ -n "$1" ]]; then
    $PYTHON $@
  elif command-exists ipython; then
    ipython
  else
    $PYTHON
  fi
}

sp() {
  if [[ -z "$1" ]]; then
    screen
  elif [[ -f "$HOME/.screen/$1" ]]; then
    screen -c "$HOME/.screen/$1"
  else
    echo "Unknown screen profile '$1'."
  fi
}

################################################################################
# Complete options
################################################################################

if [[ -d "${NOTE_PATH-$HOME/.notes}" ]]; then
  complete -W "$( ls ${NOTE_PATH-$HOME/.notes} )" note
fi

if [[ -f "$HOME/.ssh/known_hosts" ]]; then
  complete -W "$(echo $(cat $HOME/.ssh/known_hosts | \
    cut -f 1 -d ' ' | sed -e s/,.*//g | \
    sort -u | grep -v "\["))" ssh
fi

################################################################################
# Setttings
################################################################################

alias desktop="cd $HOME/Desktop"
alias download="cd $HOME/Downloads"
alias ll='ls -lh'
alias reload="source $HOME/.bashrc"
alias src="cd $HOME/src"
alias vi='echo Just type vim, it will save you time in the long run.'

export BACKUP_PATH="$HOME/Dropbox/Backups"
export DJANGO_ENV="dev"
export EDITOR='vim'
export GOROOT="$HOME/src/go"
export GOPATH="$HOME/src/go"
export HISTCONTROL='ignoreboth'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export PS1='[\u@\h \W]$ '

grow-path PATH "$HOME/.local/bin"
grow-path PATH "$HOME/src/go/bin"
grow-path PATH "./bin"
grow-path PATH "./node_modules/.bin"

set -o vi
set bell-style none

shopt -s checkwinsize
shopt -s histappend

################################################################################
# OS specific settings
################################################################################

load-darwin() {
  export PLATFORM='darwin'
  alias ls='ls -G'
}

load-freebsd() {
  export PLATFORM='freebsd'
}

load-linux() {
  export PLATFORM='linux'

  grow-path PATH '/sbin'
  grow-path PATH '/usr/sbin'
  grow-path PATH '/usr/local/sbin'

  if command-exists service; then
    complete -W "$( ls /etc/init.d/ )" service
  fi

  export LD_LIBRARY_PATH='.'
}

load-netbsd() {
  export PLATFORM='netbsd'
}

# Load OS specific settings
case "`uname`" in
  'Darwin')
    load-darwin ;;
  'FreeBSD')
    load-freebsd ;;
  'Linux')
    load-linux ;;
  'NetBSD')
    load-netbsd ;;
esac

################################################################################
# Local environment
################################################################################

if [ -f "$HOME/.bash_$( hostname )" ]; then
  . "$HOME/.bash_$( hostname )"
fi

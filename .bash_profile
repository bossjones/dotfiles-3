################################################################################
# Helper Functions
################################################################################

function command_exists {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

function extend_path {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$PATH:$1"
  fi
}

function random_line {
  LINES=$( wc -l "$1" | awk '{ print ($1 + 1) }' )
  RANDSEED=$( date '+%S%M%I' )
  LINE=$( cat "$1" | awk -v "COUNT=$LINES" -v "SEED=$RANDSEED" 'BEGIN { srand(SEED); i=int(rand()*COUNT) } FNR==i { print $0 }' )
  echo "$LINE"
}

function string_slice {
  STRING="$1"
  declare -i LENGTH="${#STRING}"
  declare -i START="$2"
  declare -i END="$3"
  if [ $START -lt 0 ]; then
    START=$[ $LENGTH + $START ]
  fi
  if [ $END -le 0 ]; then
    END=$[ $LENGTH + $END ]
  fi
  START=$[ $START + 1 ]
  (echo "$STRING" | cut -c $START-$END) 2> /dev/null
}

################################################################################
# Setttings
################################################################################

alias config="git --git-dir=$HOME/.config.git/ --work-tree=$HOME"
alias fedora='ssh silas@fedorapeople.org'
alias ll='ls -lh'
alias lr='ls -R'
alias nc='nc -v'
alias reload="source $HOME/.bash_profile"
alias root="sudo bash --init-file $HOME/.bash_profile"
alias sdf='ssh silas@tty.freeshell.net'
alias srpm='rpmbuild -bs --nodeps'
alias vi='echo Just type vim, it will save you time in the long run.'

export CDPATH=':..:~:~/resources'
export CVS_RSH='ssh'
export CVSROOT=':ext:silas@cvs.fedoraproject.org:/cvs/pkgs'
export EDITOR='vim'
export HISTCONTROL='ignoreboth'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export PS1='[\u@\h \W]$ '
export PYTHON='/usr/bin/env python'

extend_path "$HOME/.local/bin"

set -o vi

shopt -s checkwinsize
shopt -s histappend

################################################################################
# Functions
################################################################################

function archive {
  DIR="$HOME/Backup/$(date +%y/%m/%d)"
  mkdir -p "$DIR" && mv "$1" "$DIR/"
}

function backup {
  DIR="$HOME/Backup/$(date +%y/%m/%d)"
  mkdir -p "$DIR" && cp -r "$1" "$DIR/"
}

function dns_clear {
  case "$PLATFORM" in
    'darwin')
      dscacheutil -flushcache ;;
    *)
      echo Not supported ;;
  esac
}

function get {
  case "$PLATFORM" in
    'darwin')
      curl -O "$1" ;;
    *)
      wget "$1" ;;
  esac
}

function predate {
  mv "$1" "$(date +%Y-%m-%d)-$1"
}

function profile {
  "$EDITOR" "$HOME/.bash_profile"
  reload
}

function python {
  if [[ -n "$1" ]]; then
    $PYTHON $@
  elif command_exists 'ipython'; then
    ipython
  else
    $PYTHON
  fi
}

function rpm-extract {
  rpm2cpio "$1" | cpio -idmv
}

function tip {
  echo `random_line "$HOME/.tips"`
}

function update {
  if command_exists 'git'; then
    config commit -a --untracked-files=no
    config pull
    config push
    reload
  else
    echo 'Please install Git.'
  fi
}

################################################################################
# OS specific settings
################################################################################

function load_darwin {
  export PLATFORM='darwin'

  # Fix screen
  alias ls='ls -G'
  alias screen="export SCREENPWD=$(pwd); /usr/bin/screen"
  export SHELL="/bin/bash -rcfile $HOME/.bash_profile"

  # Switch to current working directory when screen is started
  if [[ "$TERM" == 'screen' ]]; then
    cd "$SCREENPWD"
  fi

  # Load Fink on OS X
  if [[ -r /sw/bin/init.sh ]]; then
    . /sw/bin/init.sh
  fi

  # Enable programmable completion (if available)
  if [ -f /sw/etc/bash_completion ]; then
    . /sw/etc/bash_completion
  else
    echo "No bash completion."
  fi
}

function load_freebsd {
  export PLATFORM='freebsd'
}

function load_linux {
  export PLATFORM='linux'
  extend_path '/sbin'
  extend_path '/usr/sbin'
  extend_path '/usr/local/sbin'
  alias show_mock="ls -1 /etc/mock/ | cut -d'.' -f1 | egrep '(86|64|ppc|sparc|90)'"

  # Enable programmable completion (if available)
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  else
    echo "No bash completion."
  fi
}

function load_netbsd {
  export PLATFORM='netbsd'
}

# Load OS specific settings
case "`uname`" in
  'Darwin')
    load_darwin ;;
  'FreeBSD')
    load_freebsd ;;
  'Linux')
    load_linux ;;
  'NetBSD')
    load_netbsd ;;
esac

################################################################################
# Local environment
################################################################################

# Load local configuration settings
if [ -f "$HOME/.bash_local" ]; then
  . "$HOME/.bash_local"
fi

################################################################################
# Run at start
################################################################################

tip

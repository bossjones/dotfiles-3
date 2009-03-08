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

################################################################################
# Aliases
################################################################################

alias config='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
alias reload='source $HOME/.bash_profile'
alias sdf='ssh silas@tty.freeshell.net'

################################################################################
# Exports
################################################################################

export EDITOR='vim'
export PS1='[\u@\h \W]$ '
extend_path "$HOME/.local/bin"

################################################################################
# Functions
################################################################################

function get {
  case "$PLATFORM" in
    'darwin')
      curl -O "$1" ;;
    *)
      wget "$1" ;;
  esac
}

function profile {
  "$EDITOR" "$HOME/.bash_profile"
  reload
}

function python {
  if [[ -n "$1" ]]; then
    python $@
  elif command_exists 'ipython'; then
    ipython
  else
    python
  fi
}

function update {
  if command_exists 'git'; then
    config commit -a --untracked-files=no && config push
    config pull
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
  alias screen='export SCREENPWD=$(pwd); /usr/bin/screen'
  export SHELL='/bin/bash -rcfile ~/.bash_profile'

  # Switch to current working directory when screen is started
  if [[ "$TERM" == 'screen' ]]; then
    cd "$SCREENPWD"
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
# Settings
################################################################################

set -o vi

################################################################################
# Local environment
################################################################################

# Use bashrc for local configuration options
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

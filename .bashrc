################################################################################
# Global environment
################################################################################

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

################################################################################
# Libraries
################################################################################

if [[ -d "$HOME/.bash_lib" ]]; then
  source "$HOME/.bash_lib/"*
fi

################################################################################
# Functions
################################################################################

config() {
  command="git --git-dir=$HOME/.config.git/ --work-tree=$HOME"
  case "$1" in
  'add')
    $command $@ -f
    ;;
  *)
    $command $@
    ;;
  esac
}

dj() {
  name="$( basename $PWD )"
  command="$1"; shift
  virtualenv=${VIRTUALENV-dev}

  if [[ -f ${virtualenv}/bin/activate ]]; then
    deactivate &>/dev/null
    source ${virtualenv}/bin/activate
  fi

  case $command in
    'run')
	  command='runserver'
	  ;;
  esac

  if [[ -f "./manage.py" ]]; then
    python "./manage.py" $command $@
  elif [[ -f "$name/manage.py" ]]; then
    python "$name/manage.py" $command $@
  else
    echo "Can't find manage.py"
  fi
}

git-dist() {
  name="$1"
  tag="$2"
  git archive --format=tar --prefix="$name-$tag/" "$tag" | bzip2 > "$name-$tag".tar.bz2
}

junk() {
  code=0

  mkdir -p "$HOME/Junk"

  for path in $@; do
    name=$( basename $path )

    if [[ ! -e "$path" ]]; then
      echo "Source doesn't exist: $path" >&2
      code=2

      continue
    fi

    if [[ -e "$HOME/Junk/$name" ]]; then
      echo "Destination already exists: $name" >&2
      code=2

      continue
    fi

    if [[ ! $( mv "$path" "$HOME/Junk" ) ]]; then
      code=2
    fi
  done

  return $code
}

httpify() {
  if [[ -d "$1" ]]; then
    cd "$1"
    shift
  fi
  python -m SimpleHTTPServer $@
}

profile() {
  "$EDITOR" "$HOME/.bashrc"
  reload
}

p() {
  if [[ -n "$1" ]]; then
    $PYTHON $@
  elif command-exists ipython; then
    ipython
  else
    $PYTHON
  fi
}

rip-iso() {
  case "$PLATFORM" in
    'darwin')
      hdiutil makehybrid -o "$1" /dev/disk1 -verbose
      ;;
    'linux')
      dd if=/dev/cdrom of="$1"
      ;;
    *)
      echo Not supported
      ;;
  esac
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

update() {
  if command-exists git; then
    config commit -a --untracked-files=no
    config pull
    config push
    reload
  else
    echo 'Please install Git.'
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
alias fedora='ssh silas@fedorapeople.org'
alias freeshell='ssh silas@tty.freeshell.net'
alias ll='ls -lh'
alias reload="source $HOME/.bashrc"
alias root="sudo bash --init-file $HOME/.bashrc"
alias src="cd $HOME/src"
alias vi='echo Just type vim, it will save you time in the long run.'

export BACKUP_PATH="$HOME/Dropbox/Backups"
export DJANGO_ENV="dev"
export EDITOR='vim'
export GEM_HOME="$HOME/.gem"
export GOROOT="$HOME/src/go"
export HISTCONTROL='ignoreboth'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export PS1='[\u@\h \W]$ '
export PYTHON='/usr/bin/env python'

grow-path PATH "$HOME/.gem/bin"
grow-path PATH "$HOME/.local/bin"
grow-path PATH "$HOME/src/go/bin"
grow-path PATH "$HOME/src/scripts"
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

  alias copy='pbcopy'
  alias paste='pbpaste'
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

  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  fi
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

# Load local configuration settings
if [ -f "$HOME/.bash_local" ]; then
  . "$HOME/.bash_local"
fi

# Load host configuration settings
if [ -f "$HOME/.bash_$( hostname )" ]; then
  . "$HOME/.bash_$( hostname )"
fi

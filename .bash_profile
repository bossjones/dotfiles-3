################################################################################
# Helper Functions
################################################################################

function calc {
  echo "$@" | bc
}

function command_exists {
  if command -v "$1" &>/dev/null; then
    return 0
  else
    return 1
  fi
}

function command_run {
  `dirname $( whereis -b "$1" | awk '{ print $2 '} )`/$@
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

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../../'
alias fedora='ssh silas@fedorapeople.org'
alias lessf='less +F'
alias ll='ls -lh'
alias lr='ls -R'
alias reload="source $HOME/.bash_profile"
alias root="sudo bash --init-file $HOME/.bash_profile"
alias sdf='ssh silas@tty.freeshell.net'
alias srpm='rpmbuild -bs --nodeps'
alias today='date +"%Y-%m-%d"'
alias now='date +"%Y-%m-%d-%H%M%S"'
alias vi='echo Just type vim, it will save you time in the long run.'

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

function clean_all {
  case "$PLATFORM" in
    'darwin')
      dscacheutil -flushcache
      find "$HOME" -name '.DS_Store' -delete
      find "$HOME" -name \.\* -maxdepth 1 -exec rm -fr {} \;
      rm -fr "$HOME/Library/"*
      ;;
    'linux')
      find "$HOME" -name \.\* -maxdepth 1 -exec rm -fr {} \;
      ;;
    *)
      echo Not supported
      ;;
  esac
}

function clean {
  case "$PLATFORM" in
    'darwin')
      dscacheutil -flushcache
      find "$HOME" -name '.DS_Store' -delete
      find "$HOME/Library/Application Support/Chromium/Default" -type f -not -name Preferences -not -name 'Web Data' -delete
      rm -fr "$HOME/Library/Caches/"*
      rm -fr "$HOME/Library/Cookies/"*
      rm -fr "$HOME/Library/Logs/"*
      rm -fr "$HOME/Library/Safari/"*
      rm -fr "$HOME/Library/Preferences/Macromedia/"*
      rm -fr "$HOME/Library/Preferences/VLC/"*
      ;;
    *)
      echo Not supported
      ;;
  esac
}

function extract {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz)  tar xvzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.rpm)     rpm2cpio "$1" | cpio -idmv ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xvf "$1" ;;
            *.tbz2)    tar xvjf "$1" ;;
            *.tgz)     tar xvzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function get {
  case "$PLATFORM" in
    'darwin')
      curl -O "$1" ;;
    *)
      wget "$1" ;;
  esac
}

function gmail {
  curl -u silassewell --silent "https://mail.google.com/mail/feed/atom" |\
  perl -ne 'print "\t" if /<name>/; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'
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

function config {
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

function vless {
  if test -t 1; then
    if test $# = 0; then
      vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' -
    else
      vim --cmd 'let no_plugin_maps = 1' -c 'runtime! macros/less.vim' "$@"
    fi
  else
    # Output is not a terminal, cat arguments or stdin
    if test $# = 0; then
      cat
    else
      cat "$@"
    fi
  fi
}

################################################################################
# OS specific settings
################################################################################

function load_darwin {
  export PLATFORM='darwin'

  alias copy='pbcopy'
  alias paste='pbpaste'
  alias ls='ls -G'
  alias screen="/usr/bin/screen /bin/bash -rcfile /Users/silas/.bash_profile"

  # Load Fink on OS X
  if [[ -r /sw/bin/init.sh ]]; then
    . /sw/bin/init.sh
  fi

  # Setup Java
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"
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
  alias build_epel='rpmbuild -bs --nodeps --define "_source_filedigest_algorithm md5" --define "_binary_filedigest_algorithm md5"'
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

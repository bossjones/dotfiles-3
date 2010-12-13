################################################################################
# Inline apps
################################################################################

git-tar-bz2() {
  name="$1"
  tag="$2"
  git archive --format=tar --prefix="$name-$tag/" "$tag" | bzip2 > "$name-$tag".tar.bz2
}

git-tar-gz() {
  name="$1"
  tag="$2"
  git archive --format=tar --prefix="$name-$tag/" "$tag" | gzip > "$name-$tag".tar.gz
}

note() {
  note-setup
  if [ -n "$*" ]; then
    vim "$HOME/.notes/$*"
  else
    vim "$HOME/.notes/$( date +%Y-%m-%d )"
  fi
}

note-cat() {
  if [ -n "$*" ]; then
    note-setup
    cat "$HOME/.notes/$*"
  else
    echo "Note name required."
  fi
}

note-copy() {
  if [ -n "$*" ]; then
    note-setup
    cat "$HOME/.notes/$*" | copy
  else
    echo "Note name required."
  fi
}

note-grep() {
  note-setup
  grep "$*" "$HOME/.notes"
}

note-ls() {
  note-setup
  if [ -n "$*" ]; then
    find "$HOME/.notes" -type f -name "*$**" -exec basename {} \;
  else
    find "$HOME/.notes" -type f -exec basename {} \;
  fi
}

note-path() {
  if [ -n "$*" ]; then
    echo "$HOME/.notes/$*"
  else
    echo "Note name required."
  fi
}

note-paste() {
  if [ -n "$*" ]; then
    note-setup
    paste > "$HOME/.notes/$*"
  else
    echo "Note name required."
  fi
}

note-rm() {
  if [ -n "$*" ]; then
    note-setup
    rm -f "$HOME/.notes/$*"
  else
    echo "Note name required."
  fi
}

note-setup() {
  if [ ! -e "$HOME/.notes" ]; then
    mkdir -p "$HOME/.notes"
  fi
}

note-yesterday() {
  note $( date -v -1d +%Y-%m-%d )
}

setup-fedora() {
  sudo yum install -y \
    @virtualization \
    Django \
    Django-south \
    curl \
    erlang \
    fedpkg \
    gcc \
    gcc-c++ \
    git \
    gnome-do \
    gnome-do-plugins \
    java-1.6.0-openjdk \
    keepassx \
    mock \
    pidgin \
    pidgin-otr \
    python-ipaddr \
    python-sphinx \
    python-twisted \
    rpmdevtools \
    vim-enhanced \
    wget \
    || :
}

################################################################################
# Helper Functions
################################################################################

calc() {
  echo "$@" | bc
}

command_exists() {
  if type -f "$1" &> /dev/null; then
    return 0
  else
    return 1
  fi
}

extend_path() {
  if [[ $PATH != *:$1* ]]; then
    export PATH="$PATH:$1"
  fi
}

extend_python_path() {
  if [[ -z $PYTHONPATH ]]; then
    export PYTHONPATH="$1"
  elif [[ $PYTHONPATH != *:$1* && $PYTHONPATH != $1 ]]; then
    export PYTHONPATH="$PYTHONPATH:$1"
  fi
}

random_line() {
  LINES=$( wc -l "$1" | awk '{ print ($1 + 1) }' )
  RANDSEED=$( date '+%S%M%I' )
  LINE=$( cat "$1" | awk -v "COUNT=$LINES" -v "SEED=$RANDSEED" 'BEGIN { srand(SEED); i=int(rand()*COUNT) } FNR==i { print $0 }' )
  echo "$LINE"
}

string_slice() {
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
# Complete options
################################################################################

complete -W "$(echo $(cat ~/.ssh/known_hosts | \
  cut -f 1 -d ' ' | sed -e s/,.*//g | \
  sort -u | grep -v "\["))" ssh

################################################################################
# Setttings
################################################################################

alias fedora='ssh silas@fedorapeople.org'
alias lessf='less +F'
alias ll='ls -lh'
alias lr='ls -R'
alias reload="source $HOME/.bash_profile"
alias root="sudo bash --init-file $HOME/.bash_profile"
alias sdf='ssh silas@tty.freeshell.net'
alias srpm='rpmbuild -bs --nodeps'
alias srpm-epel='rpmbuild -bs --define _source_filedigest_algorithm=1 --nodeps'
alias today='date +"%Y-%m-%d"'
alias todo='note todo'
alias now='date +"%Y-%m-%d-%H%M%S"'
alias vi='echo Just type vim, it will save you time in the long run.'

export EDITOR='vim'
export HISTCONTROL='ignoreboth'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export PS1='[\u@\h \W]$ '
export PYTHON='/usr/bin/env python'

extend_path "$HOME/.local/bin"
extend_path "$HOME/src/scripts"

set -o vi
set bell-style none

shopt -s checkwinsize
shopt -s histappend

################################################################################
# Functions
################################################################################

backup() {
  src_path="$1"
  dst_path="${BACKUP_PATH-$HOME/Dropbox/Backups}"
  src_name="$( basename $src_path )"
  dst_name="$( date +%Y-%m-%d )-$( basename $src_path )"

  if [[ ! -d "$src_path" ]]; then
    echo "Invalid source path: $src_path"
    exit 2
  fi

  if [[ ! -d "$dst_path" ]]; then
    echo "Invalid destination path: $dst_path"
    exit 2
  fi

  pushd "$( dirname $src_path )" > /dev/null

  if [[ -e "$dst_name" ]]; then
    echo "Desination name already exists: $dst_name"
    exit 2
  fi

  if [[ -e "$dst_path/$dst_name.tar.bz2" ]]; then
    echo "Desination path already exists: $dst_path"
    exit 2
  fi

  mv "$src_name" "$dst_name" && \
  tar -cjf "$dst_name.tar.bz2" "$dst_name" && \
  mv "$dst_name.tar.bz2" "$dst_path" && \
  mv "$dst_name" "$src_name" &&
  popd > /dev/null
}

backup-drop() {
  backup "$1" && \
  rm -fr "$1"
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

extract() {
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

predate() {
  mv "$1" "$(date +%Y-%m-%d)-$1"
}

profile() {
  "$EDITOR" "$HOME/.bash_profile"
  reload
}

python() {
  if [[ -n "$1" ]]; then
    $PYTHON $@
  elif command_exists 'ipython'; then
    ipython
  else
    $PYTHON
  fi
}

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

sp() {
  if [[ -f "$HOME/.screen/$1" ]]; then
    screen -c "$HOME/.screen/$1"
  else
    echo "Unknown screen profile '$1'."
  fi
}

update() {
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

load_darwin() {
  export PLATFORM='darwin'

  alias copy='pbcopy'
  alias paste='pbpaste'
  alias ls='ls -G'

  # Fink
  if [[ -r /sw/bin/init.sh ]]; then
    . /sw/bin/init.sh
  fi

  # MacPorts
  extend_path '/opt/local/bin'
  extend_path '/opt/local/sbin'

  # Setup Java
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home"
}

load_freebsd() {
  export PLATFORM='freebsd'
}

load_linux() {
  export PLATFORM='linux'
  extend_path '/sbin'
  extend_path '/usr/sbin'
  extend_path '/usr/local/sbin'
  alias show_mock="ls -1 /etc/mock/ | cut -d'.' -f1 | egrep '(86|64|ppc|sparc|90)'"
  alias build_epel='rpmbuild -bs --nodeps --define "_source_filedigest_algorithm md5" --define "_binary_filedigest_algorithm md5"'
  alias fmb32='mock -vr fedora-rawhide-i686'
  alias fmb64='mock -vr fedora-rawhide-x86_64'
  export LD_LIBRARY_PATH='.'
}

load_netbsd() {
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

# Load host configuration settings
if [ -f "$HOME/.bash_$HOSTNAME" ]; then
  . "$HOME/.bash_$HOSTNAME"
fi

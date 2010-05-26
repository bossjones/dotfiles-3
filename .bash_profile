################################################################################
# Inline apps
################################################################################

docs_speed() {
  echo ' --------------------------------------------------------------------------------'
  echo '| Type                                       | Speed                             |'
  echo ' --------------------------------------------------------------------------------'
  echo '| execute single instruction                 | 1 nanosec = (1/1,000,000,000) sec |'
  echo '| fetch word from L1 cache memory            | 2 nanoseci                        |'
  echo '| fetch word from main memory                | 10 nanosec                        |'
  echo '| fetch word from consecutive disk location  | 200 nanosec                       |'
  echo '| fetch word from new disk location (seek)   | 8,000,000 nanosec = 8 millisec    |'
  echo ' --------------------------------------------------------------------------------'
}

docs_cidr_mask() {
  echo ' ---------------------------------------------- '
  echo '| IP/CIDR    | Mask            | # of Hosts    |'
  echo ' ---------------------------------------------- '
  echo '| a.b.c.d/32 | 255.255.255.255 |             1 |'
  echo '| a.b.c.d/31 | 255.255.255.254 |             2 |'
  echo '| a.b.c.d/30 | 255.255.255.252 |             4 |'
  echo '| a.b.c.d/29 | 255.255.255.248 |             8 |'
  echo '| a.b.c.d/28 | 255.255.255.240 |            16 |'
  echo '| a.b.c.d/27 | 255.255.255.224 |            32 |'
  echo '| a.b.c.d/26 | 255.255.255.192 |            64 |'
  echo '| a.b.c.d/25 | 255.255.255.128 |           128 |'
  echo '| a.b.c.0/24 | 255.255.255.000 |           256 |'
  echo '| a.b.c.0/23 | 255.255.254.000 |           512 |'
  echo '| a.b.c.0/22 | 255.255.252.000 |         1,024 |'
  echo '| a.b.c.0/21 | 255.255.248.000 |         2,048 |'
  echo '| a.b.c.0/20 | 255.255.240.000 |         4,096 |'
  echo '| a.b.c.0/19 | 255.255.224.000 |         8,192 |'
  echo '| a.b.c.0/18 | 255.255.192.000 |        16,384 |'
  echo '| a.b.c.0/17 | 255.255.128.000 |        32,768 |'
  echo '| a.b.0.0/16 | 255.255.000.000 |        65,536 |'
  echo '| a.b.0.0/15 | 255.254.000.000 |       131,072 |'
  echo '| a.b.0.0/14 | 255.252.000.000 |       262,144 |'
  echo '| a.b.0.0/13 | 255.248.000.000 |       524,288 |'
  echo '| a.b.0.0/12 | 255.240.000.000 |     1,048,576 |'
  echo '| a.b.0.0/11 | 255.224.000.000 |     2,097,152 |'
  echo '| a.b.0.0/10 | 255.192.000.000 |     4,194,304 |'
  echo '| a.b.0.0/9  | 255.128.000.000 |     8,388,608 |'
  echo '| a.0.0.0/8  | 255.000.000.000 |    16,777,216 |'
  echo '| a.0.0.0/7  | 254.000.000.000 |    33,554,432 |'
  echo '| a.0.0.0/6  | 252.000.000.000 |    67,108,864 |'
  echo '| a.0.0.0/5  | 248.000.000.000 |   134,217,728 |'
  echo '| a.0.0.0/4  | 240.000.000.000 |   268,435,456 |'
  echo '| a.0.0.0/3  | 224.000.000.000 |   536,870,912 |'
  echo '| a.0.0.0/2  | 192.000.000.000 | 1,073,741,824 |'
  echo '| a.0.0.0/1  | 128.000.000.000 | 2,147,483,648 |'
  echo '| 0.0.0.0/0  | 000.000.000.000 | 4,294,967,296 |'
  echo ' ---------------------------------------------- '
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
alias srpm-epel='rpmbuild -bs --define _source_filedigest_algorithm=1 --nodeps'
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
extend_path "$HOME/src/scripts"

set -o vi
set bell-style none

shopt -s checkwinsize
shopt -s histappend

################################################################################
# Functions
################################################################################

archive() {
  DIR="$HOME/Backup/$(date +%y/%m/%d)"
  mkdir -p "$DIR" && mv "$1" "$DIR/"
}

backup() {
  DIR="$HOME/Backup/$(date +%y/%m/%d)"
  mkdir -p "$DIR" && cp -r "$1" "$DIR/"
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

clean_all() {
  case "$PLATFORM" in
    'darwin')
      clean_dns
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

clean() {
  case "$PLATFORM" in
    'darwin')
      clean_dns
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

clean_dns() {
  case "$PLATFORM" in
    'darwin')
      dscacheutil -flushcache
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

get() {
  if command_exists 'curl'; then
    curl -O "$1"
  elif command_exists 'wget'; then
    wget "$1"
  else
    echo 'No get command found.'
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

tip() {
  echo `random_line "$HOME/.tips"`
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

vless() {
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

load_darwin() {
  export PLATFORM='darwin'

  alias copy='pbcopy'
  alias paste='pbpaste'
  alias ls='ls -G'
  alias screen="/usr/bin/screen /bin/bash -rcfile /Users/silas/.bash_profile"

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

[ -f /etc/bashrc ] && . /etc/bashrc

backup() {
  code=0

  for src_path in $@; do
    dst_path="${BACKUP_PATH-$HOME/Backups}"
    src_name="$( basename $src_path )"
    dst_name="$( date +%Y-%m-%d )-$( basename $src_path )"

    if [[ ! -d "$src_path" ]]; then
      echo "Invalid source path: $src_path" 1>&2
      code=2; break
    fi

    if [[ ! -d "$dst_path" ]]; then
      echo "Invalid destination path: $dst_path" 1>&2
      code=2; break
    fi

    if ! pushd "$( dirname $src_path )" > /dev/null; then
      code=2; break
    fi

    if [[ -e "$dst_name" ]]; then
      echo "Desination name already exists: $dst_name" 1>&2
      code=2; break
    fi

    if [[ -e "$dst_path/$dst_name.tar.bz2" ]]; then
      echo "Desination path already exists: $dst_path" 1>&2
      code=2; break
    fi

    if ! (mv "$src_name" "$dst_name" && \
          tar cjf "$dst_name.tar.bz2" "$dst_name" && \
          mv "$dst_name.tar.bz2" "$dst_path" && \
          mv "$dst_name" "$src_name" &&
          popd > /dev/null
        ); then
      code=2; break
    fi
  done

  return $code
}

backup-drop() {
  code=0

  for path in $@; do
    if backup "$path"; then
      rm -fr "$path"
    else
      code=2; break
    fi
  done

  return $code
}

extract() {
  for path in $@; do
    if [ -f "$path" ] ; then
      case "$path" in
        *.tar.bz2) tar xvjf "$path" ;;
        *.tar.gz)  tar xvzf "$path" ;;
        *.7z)      7z x "$path" ;;
        *.Z)       uncompress "$path" ;;
        *.bz2)     bunzip2 "$path" ;;
        *.egg)     unzip "$path" ;;
        *.gz)      gunzip "$path" ;;
        *.jar)     unzip "$path" ;;
        *.rar)     unrar x "$path" ;;
        *.rpm)     rpm2cpio "$path" | cpio -idmv ;;
        *.tar)     tar xvf "$path" ;;
        *.tbz2)    tar xvjf "$path" ;;
        *.tgz)     tar xvzf "$path" ;;
        *.war)     unzip "$path" ;;
        *.zip)     unzip "$path" ;;
        *)         echo "'$path' cannot be extracted via >extract<" ;;
      esac
    else
      echo "'$path' is not a valid file"
    fi
  done
}

libgit-dist() {
  type="$1"
  tag="$2"
  name="$3"
  ext="$4"
  if [[ "$type" == "zip" ]]; then
    git archive --format=zip --prefix="${name}-${tag}/" "$tag" > "${name}-${tag}.${ext}"
  else
    git archive --format=tar --prefix="${name}-${tag}/" "$tag" | $type > "${name}-${tag}.${ext}"
  fi
}

git-dist() {
  name="$( basename "$( pwd )" )"
  case "${2-gzip}" in
    "bzip2")
      libgit-dist bzip2 "$1" "${3-$name}" "${4-tar.bz2}"
      ;;
    "gzip")
      libgit-dist gzip "$1" "${3-$name}" "${4-tar.gz}"
      ;;
    "zip")
      libgit-dist zip "$1" "${3-$name}" "${4-zip}"
      ;;
    *)
      echo "Unknown type: $2"
      return 1
      ;;
  esac
}

goto() {
  name="$1"
  path="${HOME}/.goto/${name}"

  if [[ ! -e $path ]]; then
    echo "Not found: $name"
    return 1
  fi

  if [[ -L $path ]]; then
    cd $path
    cd $( pwd -P )
  elif [[ -x $path ]]; then
    $path
  else
    echo "Unknown file type: $name"
    return 1
  fi
}

grow-path() {
  name="$1"
  path_list="${!name}"
  path="$2"
  append="$3"

  if [[ $path_list == "" ]]; then
    export $name="$path"
  elif [[ $path_list != $path && $path_list != $path:* && $path_list != *:$path:* && $path_list != *:$path ]]; then
    if [[ -n $append ]]; then
      export $name="$path_list:$path"
    else
      export $name="$path:$path_list"
    fi
  fi
}

grow-path-exists() {
  if [[ -d "$2" ]]; then
    grow-path "$@"
  fi
}

p() {
  if [[ -n "$1" ]]; then
    $PYTHON "$@"
  elif type -f ipython &>/dev/null; then
    ipython
  else
    $PYTHON
  fi
}

install_bash() {
  curl -s 'https://raw.githubusercontent.com/silas/dot/master/dot' \
    -o ~/.local/bin/dot
  chmod 755 ~/.local/bin/dot
}

install_darwin() {
  brew update
  brew install \
    bash \
    boot2docker \
    coreutils \
    curl \
    docker \
    git \
    go --cross-compile-common \
    hg \
    httpie \
    jq \
    ngrok \
    node \
    the_silver_searcher \
    tmux \
    vim
  brew tap rockstack/rock
  brew install \
    rock-cli
  brew tap silas/silas
  brew install \
    dot \
    fabric \
    keyfu
}

install_go() {
  go get -u code.google.com/p/go.tools/cmd/cover
  go get -u code.google.com/p/go.tools/cmd/godoc
  go get -u code.google.com/p/go.tools/cmd/goimports
  go get -u github.com/golang/lint/golint
  go get -u github.com/jstemmer/gotags
  go get -u github.com/mitchellh/gox
  go get -u github.com/tools/godep
}

install_linux_deb() {
  sudo apt-get install -y \
    curl \
    git
}

install_linux_rpm() {
  sudo yum install -y \
    curl \
    git \
    vim-enhanced
}

install_linux() {
  sudo yum install vim-enhanced
  if type -f apt-get &>/dev/null; then
    install_linux_deb
  elif type -f yum &>/dev/null; then
    install_linux_rpm
  fi
}

install_vim() {
  mkdir -p ~/.vim/autoload
  curl -fLo ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_all() {
  install_bash
  install_$OS
  if type -f go &>/dev/null; then
    install_go
  fi
  install_vim
}

kf() {
  vim "$HOME/.keyfu/$1.js"
}

qo() {
  path=$( find . -name "$1" -type f )

  if [[ -n "$path" ]]; then
    vim $path
  else
    echo "Not found: $1" 1>&2
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

src() {
  for path in "${SRC_PATHS[@]}"; do
    if [[ -d "$path/$1" ]]; then
      cd "$path/$1"
      break
    fi
  done
}

template() {
  name="$1"
  if [[ -f "$name" ]]; then
    echo "$name already exists." >&1
    return 1
  fi
  cp -f "$HOME/.template/$name" "./$name"
}

alias ll='ls -lh'
alias pp='git pull --rebase && git push'
alias reload="source $HOME/.bashrc"

export EDITOR='vim'
export GIT_MERGE_AUTOEDIT='no'
export GOPATH="$HOME/src/go"
export HISTCONTROL='ignoreboth'
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LSCOLORS='ExGxBxDxCxEgEdxbxgxcxd'
export OS=$( uname -s | tr '[:upper:]' '[:lower:]' )
export PORT='8000'
export PS1='[\u@\h \W]$ '
export SRC_PATHS=(~/src ~/src/go/src/github.com/silas ~/src/go/src/github.com)
export TMOUT=0

grow-path-exists PATH '/usr/sbin'
grow-path-exists PATH "$GOROOT/bin"
grow-path-exists PATH "$GOPATH/bin"
grow-path-exists PATH "/usr/local/bin:$PATH"
grow-path-exists PATH "$HOME/.local/bin"
grow-path PATH "./node_modules/.bin:$PATH"

set -o vi
set bell-style none

shopt -s checkwinsize
shopt -s histappend

complete -W "$( ls ~/.screen )" sp
complete -W "$( ls ${SRC_PATHS[*]} 2>/dev/null )" src
complete -W "$( python ~/.local/bin/known_hosts.py )" ssh

[ -f ~/.bash_$OS ] && . ~/.bash_$OS
[ -f ~/.bash_local ] && . ~/.bash_local

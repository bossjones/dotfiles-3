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

grow-path() {
  name="$1"
  path_list="${!name}"
  path="$2"
  prepend="$3"

  if [[ $path_list == "" ]]; then
    export $name="$path"
  elif [[ $path_list != $path && $path_list != $path:* && $path_list != *:$path:* && $path_list != *:$path ]]; then
    if [[ -n $prepend ]]; then
      export $name="$path:$path_list"
    else
      export $name="$path_list:$path"
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
  cd "$HOME/src/$1"
}

alias ll='ls -lh'
alias reload="source $HOME/.bashrc"
alias pp="git pull --rebase && git push"

export EDITOR='vim'
export GIT_MERGE_AUTOEDIT='no'
export HISTCONTROL='ignoreboth'
export LSCOLORS='ExGxBxDxCxEgEdxbxgxcxd'
export PS1='[\u@\h \W]$ '

grow-path-exists PATH "$GOROOT/bin"
grow-path-exists PATH "$HOME/src/brpm"
grow-path-exists PATH "$HOME/src/rock/rock/scripts"
grow-path-exists PATH '/opt/vagrant/bin'
grow-path-exists PATH '/sbin'
grow-path-exists PATH '/usr/sbin'
grow-path-exists PATH '/usr/local/sbin'
grow-path-exists PYTHONPATH "$HOME/src/rock/rock"

set -o vi
set bell-style none

shopt -s checkwinsize
shopt -s histappend

[ -d ~/.screen ] &&
  complete -W "$( ls ~/.screen )" sp

[ -d ~/src ] &&
  complete -W "$( ls ~/src )" src

[ -f ~/.ssh/known_hosts ] &&
  complete -W "$(echo $(cat ~/.ssh/known_hosts | \
    cut -f 1 -d ' ' | sed -e s/,.*//g | \
    sort -u | grep -v "\["))" ssh

[ -f ~/.bash_local ] && . ~/.bash_local

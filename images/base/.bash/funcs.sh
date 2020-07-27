#! /bin/bash

function src() {
  . ~/.bashrc 2>/dev/null
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$@"
}

function md() {
  mkdir -p "$@" && cd "$@"
}

function xtree() {
  find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

function mktar() {
  tar cvzf "${1%%/}.tar.gz" "${1%%/}/"
}

function mkzip() {
  zip -r "${1%%/}.zip" "$1"
}

function sanitize() {
  chmod -R u=rwX,g=rX,o= "$@"
}

function mp() {
  ps "$@" -u $USER -o pid,%cpu,%mem,bsdtime,command
}

function pp() {
  mp f | awk '!/awk/ && $0~var' var=${1:-".*"}
}

function ff() {
  find . -type f -iname '*'"$*"'*' -ls
}

function fe() {
  find . -type f -iname '*'"${1:-}"'*' -exec ${2:-file} {} \;
}

function arc() {
  arg="$1"
  shift
  case $arg in
  -e | --extract)
    if [[ $1 && -e $1 ]]; then
      case $1 in
      *.tbz2 | *.tar.bz2) tar xvjf "$1" ;;
      *.tgz | *.tar.gz) tar xvzf "$1" ;;
      *.tar.xz) tar xpvf "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.gz) gunzip "$1" ;;
      *.zip) unzip "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.7zip) 7za e "$1" ;;
      *.rar) unrar x "$1" ;;
      *) printf "'%s' cannot be extracted" "$1" ;;
      esac
    else
      printf "'%s' is not a valid file" "$1"
    fi
    ;;
  -n | --new)
    case $1 in
    *.tar.*)
      name="${1%.*}"
      ext="${1#*.tar}"
      shift
      tar cvf "$name" "$@"
      case $ext in
      .gz) gzip -9r "$name" ;;
      .bz2) bzip2 -9zv "$name" ;;
      esac
      ;;
    *.gz)
      shift
      gzip -9rk "$@"
      ;;
    *.zip) zip -9r "$@" ;;
    *.7z) 7z a -mx9 "$@" ;;
    *) printf "bad/unsupported extension" ;;
    esac
    ;;
  *) printf "invalid argument '%s'" "$arg" ;;
  esac
}

# Expand an alias as text - https://unix.stackexchange.com/q/463327/143394
function expand_alias() {
  if [[ -n $ZSH_VERSION ]]; then
    # shellcheck disable=2154  # aliases referenced but not assigned
    printf '%s\n' "${aliases[$1]}"
  else # bash
    printf '%s\n' "${BASH_ALIASES[$1]}"
  fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

function terminate() {
  kill -9 $(ps -ef | grep -v grep | grep $1 | awk '{print $2}')
}

function encrypt() {
  gpg --recipient $1 --encrypt-files $2
}

function decrypt() {
  gpg --decrypt-files $1
}

# Append our default paths
function appendpath() {
  case ":$PATH:" in
  *:"$1":*) ;;

  *)
    PATH="${PATH:+$PATH:}$1"
    ;;
  esac
}

# Utility to set "current working directory". For each new tab or window
# you won't need to cd to the project config every time.
function fbind() {
  case "$1" in
  -u)
    rm ~/.bindrc
    ;;
  -c)
    if [ -f ~/.bindrc ]; then
      cd $(cat ~/.bindrc)
    fi
    ;;
  *)
    echo $(readlink -f "$1") >~/.bindrc
    ;;
  esac
}

function gc() {
	local commit='EDITOR=nvim git commit || bash'
	local diff='GIT_PAGER="less -+F" git diff --staged'

	tmux new-window "$commit" \; split-window -dh "$diff"
}

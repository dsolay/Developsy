#! /bin/bash

# Shorter version of a common command that it used herein.
_checkexec() {
  command -v "$1" > /dev/null
}

# Back up a file. Usage "backupthis <filename>"
backupthis() {
  cp -riv "$1" "${1}-$(date +%Y%m%d%H%M)".backup;
}

# shell helper functions
# mostly written by Nathaniel Maia, some pilfered from around the web

# better ls and cd
unalias ls >/dev/null 2>&1
ls()
{
  command ls --color=auto -F "$@"
}

unalias cd >/dev/null 2>&1
# Enter directory and list contents
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls -pvA --color=auto --group-directories-first
  else
    builtin cd ~ && ls -pvA --color=auto --group-directories-first
  fi
}

src()
{
  # shellcheck source=../.bashrc
  source ~/.bashrc 2> /dev/null
}

nh()
{
  nohup "$@" &>/dev/null &
}

hex2dec()
{
  awk 'BEGIN { printf "%d\n",0x$1}'
}

dec2hex()
{
  awk 'BEGIN { printf "%x\n",$1}'
}

mktar()
{
  tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"
}

mkzip()
{
  zip -r "${1%%/}.zip" "$1"
}

sanitize()
{
  chmod -R u=rwX,g=rX,o= "$@"
}

mp()
{
  ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command
}

pp()
{
  mp f | awk '!/awk/ && $0~var' var="${1:-".*"}"
}

ff()
{
  find . -type f -iname '*'"$*"'*' -ls
}

fe()
{
  find . -type f -iname '*'"${1:-}"'*' -exec "${2:-file}" {} \;
}

# Create a new directory and enter it
mkd()
{
  mkdir -p "$@" && cd "$@" || exit
}

arc()
{
  arg="$1"; shift
  case $arg in
    -e|--extract)
      if [[ $1 && -e $1 ]]; then
        case $1 in
          *.tbz2|*.tar.bz2) tar xvjf "$1" ;;
          *.tgz|*.tar.gz) tar xvzf "$1" ;;
          *.tar.xz) tar xpvf "$1" ;;
          *.tar) tar xvf "$1" ;;
          *.gz) gunzip "$1" ;;
          *.zip) unzip "$1" ;;
          *.bz2) bunzip2 "$1" ;;
          *.7zip) 7za e "$1" ;;
          *.rar) unrar x "$1" ;;
          *) printf "'%s' cannot be extracted" "$1"
        esac
      else
        printf "'%s' is not a valid file" "$1"
        fi ;;
      -n|--new)
        case $1 in
          *.tar.*)
            name="${1%.*}"
            ext="${1#*.tar}"; shift
            tar cvf "$name" "$@"
            case $ext in
              .gz) gzip -9r "$name" ;;
              .bz2) bzip2 -9zv "$name"
            esac ;;
          *.gz) shift; gzip -9rk "$@" ;;
          *.zip) zip -9r "$@" ;;
          *.7z) 7z a -mx9 "$@" ;;
          *) printf "bad/unsupported extension"
        esac ;;
      *) printf "invalid argument '%s'" "$arg"
    esac
}

killp()
{
  local pid name sig="-TERM"   # default signal
  [[ $# -lt 1 || $# -gt 2 ]] && printf "Usage: killp [-SIGNAL] pattern" && return 1
  [[ $# -eq 2 ]] && sig=$1
  for pid in $(mp | awk '!/awk/ && $0~pat { print $1 }' pat=${!#}); do
    name=$(mp | awk '$1~var { print $5 }' var="$pid")
    ask "Kill process $pid <$name> with signal $sig?" && kill "$sig" "$pid"
  done
}

xtree()
{
  find "${1:-.}" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# Expand an alias as text - https://unix.stackexchange.com/q/463327/143394
expand_alias()
{
  if [[ -n $ZSH_VERSION ]]; then
    # shellcheck disable=2154  # aliases referenced but not assigned
    printf '%s\n' "${aliases[$1]}"
  else # bash
    printf '%s\n' "${BASH_ALIASES[$1]}"
  fi
}

# Determine size of a file or total size of a directory
fs()
{
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$*" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

terminate()
{
  for pid in $(pgrep "$1")
  do 
    kill -9 "$pid"
  done
}

encrypt()
{
  gpg --recipient "$1" --encrypt-files "$2"
}

decrypt()
{
  gpg --decrypt-files "$1"
}

# Append our default paths
appendpath()
{
  case ":$PATH:" in
  *:"$1":*)
    ;;
  *)
    PATH="${PATH:+$PATH:}$1"
    ;;
  esac
}

prependpath () {
  case ":$PATH:" in
    *:"$1":*)
      ;;
    *)
      PATH="$1:${PATH:+$PATH}"
  esac
}

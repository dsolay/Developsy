#! /bin/bash

# add anyenv to path
prependpath "$HOME/.anyenv/bin"

# Include my scripts in the PATH.  To avoid conflicts, I always prepend
# `own_script_` to my files.  There are some exceptions though, where I
# am confident that no conflicts will arrise.  See the 'bin' directory
# of my dotfiles.
[ -d "$HOME/bin" ] && appendpath "$HOME/bin"

# Add pip user packages to PATH
[ -d "$HOME/.local/bin" ] && appendpath "$HOME/.local/bin"

# Default editor.  On Debian the Vim GUI is provided by a separate
# package.
export EDITOR=nvim

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

# gpg
export GNUPGHOME="$HOME/.gnupg/"

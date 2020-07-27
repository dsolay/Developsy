#
# ~/.bashrc
#

# Description
# ===========
#
# BASH configuration file.  Any modules such as the `dircolors` config
# are stored in ~/.local/share/my_bash/.  This setup is part of my
# dotfiles.  See https://gitlab.com/protesilaos/dotfiles.
#
# Note that ALL MY SCRIPTS are designed to work with `#!/bin/bash`.
# They are not tested for portability.
#
# Last full review on 2019-06-28

# Shorter version of a common command that it used herein.
_checkexec() {
	command -v "$1" > /dev/null
}

# General settings
# ================

# Default pager.  Note that the option I pass to it will quit once you
# try to scroll past the end of the file.
export PAGER="less --quit-at-eof"
export MANPAGER=$PAGER

# Simple prompt
if [ -n "$SSH_CONNECTION" ]; then
	export PS1="\u@\h: \w \$ "
else
	export PS1="\w \$ "
fi
export PS2="> "

# The following is taken from the .bashrc shipped with Debian 9.  Enable
# programmable completion features (you don't need to enable this, if
# it's already enabled in /etc/bash.bashrc and /etc/profile sources
# /etc/bash.bashrc).
if ! shopt -oq posix; then
	[ -f ~/.bash/bash-completion.bash ] && . ~/.bash/bash-completion.bash
fi

# Enable tab completion when starting a command with 'sudo'
[ "$PS1" ] && complete -cf sudo

# If not running interactively, don't do anything.  This too is taken
# from Debian 9's bashrc.
case $- in
	*i*) ;;
	  *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See `man bash` for more options.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in `man bash`.
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary, update the
# values of LINES and COLUMNS.
shopt -s checkwinsize

# Make `less` more friendly for non-text input files.
_checkexec lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

# Load aliases
[ -f ~/.bash/aliases.sh ] && . ~/.bash/aliases.sh

# Load functions
[ -f ~/.bash/funcs.sh ] && . ~/.bash/funcs.sh

# Powerline configuration
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/share/powerline/bindings/bash/powerline.sh
fi

export FZF_DEFAULT_OPTS='--color=light,hl:12,hl+:15,info:10,bg+:4'

if [ "$(command -v fzf 2> /dev/null)" ]; then
	[ -f ~/.bash/fzf/key-bindings.bash ] && . ~/.bash/fzf/key-bindings.bash
	[ -f ~/.bash/fzf/fzf-completion.bash ] && . ~/.bash/fzf/fzf-completion.bash

	# Load plugins
	source ~/.bash/fzf/fzf-plugins/commons.plugin.bash
	source ~/.bash/fzf/fzf-plugins/directory.plugin.bash
	source ~/.bash/fzf/fzf-plugins/forgit.plugin.bash
	source ~/.bash/fzf/fzf-plugins/tmux.plugin.bash
fi

fbind -c

# gpg
export GNUPGHOME="~/.gnupg/"

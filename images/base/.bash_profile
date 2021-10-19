#! /bin/bash
#
# ~/.bash_profile
#

# load env
# shellcheck source=.bashrc
[[ -f ~/.bashrc ]] && source ~/.bashrc
[[ -f ~/.bash/env.bash ]] && source ~/.bash/env.bash

# load anyenv config
_checkexec anyenv && eval "$(anyenv init -)"

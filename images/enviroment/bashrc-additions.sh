[ -d "$HOME/.local/bin" ] && appendpath "$HOME/.local/bin"
[ -d "/root/.local/bin" ] && appendpath "/root/.local/bin"

export TERM=screen-256color
export EDITOR=nvim

alias vim='nvim'

function gc() {
	local commit='EDITOR=nvim git commit || bash' 
	local diff='GIT_PAGER="less -+F" git diff --staged' 

	tmux new-window "$commit" \; split-window -dh "$diff"
}

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1 \
POWERLINE_BASH_SELECT=1 \
	. /usr/local/lib/python3.6/dist-packages/powerline/bindings/bash/powerline.sh

export FZF_DEFAULT_OPTS='--color=light,hl:12,hl+:15,info:10,bg+:4'

if [ "$(command -v fzf 2> /dev/null)" ]; then
	[ -f ~/.bash/key-bindings.bash ] && . ~/.bash/key-bindings.bash
	[ -f ~/.bash/fzf-completion.bash ] && bash ~/.bash/fzf-completion.bash
fi

# Utility to set "current working directory". For each new tab or window
# you won't need to cd to the project config every time.
function fbind () {
	case "$1" in
		-u)
			rm ~/.bindrc
			;;
		-c)
			if [ -f ~/.bindrc ]; then
				cd `cat ~/.bindrc`
			fi
			;;
		*)
			echo `readlink -f "$1"` > ~/.bindrc
			;;
	esac
}

fbind -c

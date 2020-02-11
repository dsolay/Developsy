#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

get() {
  curl --continue-at - --location --progress-bar --remote-name --remote-time "$@"
}

install-tmux() {
	local tmux_tar="tmux-$TMUX_VERSION.tar.gz"
	pushd /tmp
	curl -L -o "/tmp/tmux-$TMUX_VERSION.tar.gz" \
		"https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/$tmux_tar"
	tar xzf "$tmux_tar"
	local tmux_src="/tmp/tmux-$TMUX_VERSION"
	pushd "$tmux_src"
	# libevent is a run-time requirement. *-dev are for the header files.
	local libevent_version=2.0-5
	if [ "$UBUNTU_RELEASE" == "bionic" ]; then
		libevent_version=2.1-6
	fi
	apt-install "libevent-$libevent_version" libevent-dev libncurses-dev
	./configure
	make
	sudo make install
	popd
	rm -rf "$tmux_src"
	rm -rf "$tmux_tar"
	sudo apt-get purge -y libevent-dev libncurses-dev
	popd
}

install-powerline() {
	# POWER TMUX
	sudo pip3 install powerline-status

	# Make git status extra nice :)
	sudo pip3 install powerline-gitstatus
}

install-tmate() {
	curl -o /tmp/tmate.tar.gz -L https://github.com/tmate-io/tmate/releases/download/2.2.1/tmate-2.2.1-static-linux-amd64.tar.gz
	tar -xzf /tmp/tmate.tar.gz -C /tmp
	sudo cp /tmp/tmate-2.2.1-static-linux-amd64/tmate /usr/local/bin/tmate
	rm -rf /tmp/tmate*
}

install-neovim() {
	apt-install software-properties-common -y

	# Install neovim
	sudo add-apt-repository ppa:neovim-ppa/stable
	sudo apt-get update
	apt-install neovim -y

	# Install neovim python api.
	sudo pip3 install neovim

	# Python 3 api required for denite.vim
	sudo pip3 install --upgrade pip
	sudo pip3 install setuptools
	sudo pip3 install neovim
}

install-powerline-font() {
  pushd /tmp

  apt-install fontconfig

  # Install Inconsolata font
  local FONT="Inconsolata"
  get "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$FONT.zip"
  unzip "$FONT.zip"
  sudo mv *.ttf /usr/share/fonts/truetype/
  fc-cache -vf /usr/share/fonts/
  
  # Clean
  rm -rf "$FONT.zip"
  popd
}

sudo apt-get update

# Fix file permissions from the copy
sudo chown -R $USER:$USER "$HOME/.config"
sudo chown -R $USER:$USER "$HOME/.bash"
sudo chown $USER:$USER /home/$USER/.tmux.conf

# Need to update package cache...
sudo apt-get update

install-powerline-font

install-powerline

install-tmux

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-neovim

# Add bashrc addons for powerline and etc.
echo -e "\n\n" >> "$HOME/.bashrc"
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"
sudo rm /tmp/bashrc-additions.sh

# Install vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install all plugins.
nvim +PlugInstall +qall

# Shellcheck: shell script linter
apt-install shellcheck

# Install ctags for code jump
apt-install exuberant-ctags

# Add fzf fuzzy finder
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
rm -rf /tmp/shellcheck
rm -rf ~/.cabal
sudo rm -rf /var/lib/apt/lists/*
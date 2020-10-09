#! /bin/bash

set -ex

# The sudo message is annoying, so skip it
touch $HOME/.sudo_as_admin_successful
chown $USER:$USER $HOME/.sudo_as_admin_successful

# Crete bin directory in home
mkdir $HOME/bin

# fix permissions of .config directory
sudo chown -R $USER:$USER $HOME/.config

# intsll tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# intalling fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/share/fzf
$HOME/.local/share/fzf/install --bin
ln -sf $HOME/.local/share/fzf/bin/fzf $HOME/bin/fzf

# cli for git fuzzy
git clone https://github.com/bigH/git-fuzzy.git $HOME/.local/share/git-fuzzy
ln -sf $HOME/.local/share/git-fuzzy/bin/git-fuzzy $HOME/bin/git-fuzzy
curl -fLo /tmp/delta.deb https://github.com/dandavison/delta/releases/download/0.3.0/git-delta_0.3.0_amd64.deb
sudo dpkg -i /tmp/delta.deb
rm -rf /tmp/delta.deb

# intall tmux session manager
pip3 install --user tmuxp

# Install vim plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install nvim plugins (Fix me)
# nvim +PlugInstall +qall

# add support for vs code devcontainer
mkdir -p $HOME/.vscode-server/extensions

# add an alias for it that opens vim with the conflicted plugin activated
git config --global alias.conflicted '!nvim +Conflicted'

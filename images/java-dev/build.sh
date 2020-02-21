#!/usr/bin/env bash

set -e

set -x

get() {
  curl -L -o "$@"
}

install-jdtls() {
  get /tmp/jdtls.tar.gz http://download.eclipse.org/jdtls/snapshots/jdt-language-server-0.9.0-201711302113.tar.gz && \
	sudo mkdir -p $JDTLS_HOME && \
	sudo tar xvf /tmp/jdtls.tar.gz -C $JDTLS_HOME && \
	rm /tmp/jdtls.tar.gz && \
	cp -r $JDTLS_HOME/config_linux $HOME/.config/jdtls
}

# install language server
install-jdtls

# set execute permission
sudo chmod +x /usr/local/bin/jdtls

# Copy new plugins nvim
echo "" >> "$HOME/.config/nvim/plugin.vim"; \
for file in post-plugin.vim plugin.vim; do \
  cat "/tmp/$file" >> "$HOME/.config/nvim/$file"; \
  sudo rm "/tmp/$file"; \
done

# Install all plugins.
nvim +PlugInstall +qall

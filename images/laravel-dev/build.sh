#!/usr/bin/env bash

# Print out every line being run
set -x

# If a command fails, exit immediately.
set -e

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

install-php() {
    apt-install software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt-get update
    apt-install \
        php7.4-common \
        php7.4-cli \
        php7.4-gd \
        php7.4-mysql \
        php7.4-curl \
        php7.4-intl \
        php7.4-mbstring \
        php7.4-bcmath \
        php7.4-imap \
        php7.4-xml \
        php7.4-zip \
        php7.4-pgsql
}
sudo apt-get update

# Fix file permissions from the copy
sudo chown -R $USER:$USER "$HOME/.composer"

install-php

# Install composer and add its bin to the PATH.
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Install the Laravel Installer
composer global require "laravel/installer"

# Install Prestissimo
composer global require "hirak/prestissimo"

# Install postgres client
apt-install postgresql-client

# Add bashrc addons for powerline and etc.
echo -e "\n\n#Laravel bash adition\n" >> "$HOME/.bashrc"
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"
sudo rm /tmp/bashrc-additions.sh

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
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
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-imap \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-xdebug
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

# Install mysql client
apt-install mysql-client

# Install sqlite3
apt-install sqlite3

# Add bashrc addons for powerline and etc.
echo -e "\n\n# Laravel bash adition" >> "$HOME/.bashrc"
cat /tmp/bashrc-additions.sh >> "$HOME/.bashrc"
sudo rm /tmp/bashrc-additions.sh

# Add aliases for php and composer.
echo -e "\n\n# Laravel alias adition" >> "$HOME/.bash/aliases.sh"
cat /tmp/alias-additions.sh >> "$HOME/.bash/aliases.sh"
sudo rm /tmp/alias-additions.sh

# Setup docker host
IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo "Host ip is $IP"
echo "$IP   host.docker.internal" | sudo tee -a /etc/hosts

# Cleanups
sudo apt-get purge software-properties-common -y
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

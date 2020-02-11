#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -eo pipefail

# Print every line executed to the terminal
set -x

apt-install() {
	apt-get install --no-install-recommends -y "$@"
}

apt-get update

# reinstall stuff to include man pages...
sudo rm /etc/dpkg/dpkg.cfg.d/excludes
dpkg -l | \
	awk '$1 ~/ii/ { print $2 }' | \
	xargs sudo apt-get install -y --reinstall

# Super essential tools
apt-install tree curl

# Going to need this a lot
apt-install python3-pip

pip3 install setuptools

# See readme for how to get the clipboard working.
apt-install xclip

# Man pages on base debian image aren't installed...
apt-install man-db

# tldr for a short form man pages.
pip3 install tldr

# Just gitgud
pip3 install gitgud

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc.
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# cheap reverse proxy
apt-install socat

# Packet sniffer for debugging.
apt-install tcpflow tcpdump

# Very usefull for finding issues coming from syscalls
apt-install strace

# Install bash tab completion.
apt-install bash-completion

# ssh
apt-install openssh-client

# get lines of code in a directory
apt-install cloc

# pager better than less...
apt-install less

# useful for querying json
apt-install jq

# ping servers
apt-install inetutils-ping

# for figuring out routing issues in the network
apt-install inetutils-traceroute

# To cryptographically sign git commits
apt-install gpg gpg-agent

# replacement for ifconfig
apt-install iproute2

# compressions tools
apt-install zip unzip p7zip-full unrar

# Expose local servers to the internet. Useful for testing webhooks, oauth,
# etc.
curl -o /tmp/ngrok.zip \
	https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
sudo unzip /tmp/ngrok.zip -d /usr/local/bin
rm /tmp/ngrok.zip

# Install latest git
apt-install software-properties-common
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
apt-install git
sudo apt-get purge -y software-properties-common

# subcommand which opens the branch you're checked out on github.
git clone --depth 1 https://github.com/paulirish/git-open /tmp/git-open
sudo cp /tmp/git-open/git-open /usr/local/bin
rm -rf /tmp/git-open

# Required for so many languages this will simply be included by default.
apt-install build-essential pkgconf

# Mail client for testing
apt-install swaks

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# Set timezone
apt-install tzdata
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# Alias for tree view of commit history.
git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"
# cache is useless to keep
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
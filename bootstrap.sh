#!/usr/bin/env bash

DOTFILES=$(pwd)

# To stop executuion and get error with line if any error occur
set -e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

source scripts/brew.sh

source scripts/ruby.sh
source scripts/python.sh
source scripts/firebase.sh

source scripts/links.sh

source scripts/mac_os_defaults/set.sh

softwareupdate --install-rosetta

echo ''
echo 'All installed!'

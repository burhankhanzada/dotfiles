#!/usr/bin/env bash

DOTFILES=$(pwd)

# echo $DOTFILES

set -e

sudo scripts/mac_os_defaults.sh
softwareupdate --install-rosetta

source scripts/links.sh
source scripts/firebase.sh
source scripts/brew.sh
source scripts/ruby.sh

# echo ''
# echo $PATH

echo ''
echo 'All installed!'

#!/usr/bin/env bash

DOTFILES=$(pwd)

set -e

sudo scripts/mac_os_defaults.sh
softwareupdate --install-rosetta

source scripts/links.sh
source scripts/brew.sh
source scripts/ruby.sh
source scripts/python.sh
source scripts/firebase.sh

echo ''
echo 'All installed!'

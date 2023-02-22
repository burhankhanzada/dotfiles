#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

set -e

echo ''

sudo scripts/mac_os_defaults.sh
softwareupdate --install-rosetta

source scripts/links.sh
source scripts/firebase.sh
source scripts/brew.sh
# source scripts/ruby.sh

echo ''
echo $PATH

echo ''
echo 'All installed!'

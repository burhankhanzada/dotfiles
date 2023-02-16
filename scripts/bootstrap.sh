#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

set -e

echo ''

source scripts/functions.sh

sudo scripts/set_mac_os_defaults.sh
setup_gitconfig
install_dotfiles
source scripts/links.sh
brew bundle --file Brewfile

echo ''
success 'All installed!'

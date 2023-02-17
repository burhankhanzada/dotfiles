#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

set -e

echo ''

sudo scripts/set_mac_os_defaults.sh

source scripts/functions.sh
source scripts/links.sh
source scripts/links.sh
source scripts/symlinks.sh

echo ''
success 'All installed!'

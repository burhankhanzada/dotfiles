#!/usr/bin/env bash

export DOTFILES="$HOME/.dotfiles"

# To stop executuion and get error with line if any error occur
set +e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

source "$DOTFILES/mac_os/setup.sh"

source "$DOTFILES/zsh/setup.sh"

source "$DOTFILES/brew/setup.sh"

source "$DOTFILES/after_brew/setup.sh"

#!/usr/bin/env bash

sudo scripts/set_mac_os_defaults.sh

# Install Apple's Command Line Tools, which are prerequisites for Git and Homebrew.
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --file Brewfile

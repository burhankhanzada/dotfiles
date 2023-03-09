#!/usr/bin/env bash

echo ""
echo "Installing & Updating Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# echo "eval $(/opt/homebrew/bin/brew shellenv)" >>~/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

# brew bundle --file Brewfile
# brew bundle dump -f --describe

# DO NOT REORDER BELOW LINES THESE ORDER IS BASED ON PRIORITY

# TAPS
brew tap leoafarias/fvm
brew tap beeftornado/rmtree
brew tap homebrew/cask-fonts

# Apps
brew install warp
brew install google-chrome
brew install wpsoffice
brew install whatsapp
brew install motrix

#IDEs
brew install visual-studio-code
brew install android-studio
brew install fleet

# Development Tools
brew install git
brew install git-secret

# Flutter
brew install fvm

# Java
brew install openjdk@11

# Python
brew install pyenv
brew install lightgbm

# Node
brew install node

# Ruby
brew install ruby-install
brew install chruby

brew install parallels
brew install parallels-access
brew install parallels-toolbox

# Fonts
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono
brew install font-petit-formal-script

# Maintance Tools
brew install onyx

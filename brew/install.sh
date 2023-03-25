#!/usr/bin/env bash

echo ""
echo "Installing & Updating Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "eval $(/opt/homebrew/bin/brew shellenv)" >>~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

source ~/.zshrc

# brew bundle --file Brewfile
# brew bundle dump -f --describe

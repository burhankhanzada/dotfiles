#!/usr/bin/env bash

echo ''
echo 'Installing & Updating Homebrew'

brew bundle --file Brewfile
brew bundle dump -f --describe

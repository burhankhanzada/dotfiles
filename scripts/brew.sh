#!/usr/bin/env bash

echo ''
info 'Installing & Updating Homebrew'

brew bundle --file Brewfile
brew bundle dump -f --describe

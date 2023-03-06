#!/usr/bin/env bash

echo '1 - Disable press-and-hold for keys in favor of key repeat'
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo '2 - Set a fast keyboard repeat rate'
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 12

echo '2 - Disable automatic capitalization'
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

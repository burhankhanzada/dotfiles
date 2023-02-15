#!/usr/bin/env bash

# Set icon size
defaults write com.apple.dock tilesize -int 25

# Set hover icon size
defaults write com.apple.dock largesize -int 50

# Don’t automatically rearrange Spaces based on use
defaults write com.apple.dock mru-spaces -bool false

# Enable hover magnification
defaults write com.apple.dock magnification -bool true

# Do not display recent apps in the Dock
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

killall Dock

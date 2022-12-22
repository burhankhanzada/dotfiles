#!/usr/bin/env bash

# Set default image format to jpg
defaults write com.apple.screencapture typ -string jpg

# Do not include date and time in filenames
defaults write com.apple.screencapture include-date -bool false

# Remove shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Do not display the thumbnail after taking a screenshot
defaults write com.apple.screencapture show-thumbnail -bool false

# Set default location to Pictures/Screenshots
defaults write com.apple.screencapture location -string ~/Pictures/Screenshots

killall SystemUIServer

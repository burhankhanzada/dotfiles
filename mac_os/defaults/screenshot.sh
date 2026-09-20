#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Set default image format to jpg"
defaults write com.apple.screencapture type -string jpg

echo.Green "2 - Disable date and time in filenames"
defaults write com.apple.screencapture include-date -bool false

echo.Green "3 - Disable window shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo.Green "4 - Disable show thumbnail after screenshot"
defaults write com.apple.screencapture show-thumbnail -bool false

echo.Green "5 - Set default location to Pictures/Screenshots"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

killall SystemUIServer 2>/dev/null || true

#!/usr/bin/env bash

echo.Green "1 - Set default image format to jpg"
defaults write com.apple.screencapture type -string jpg

echo.Green "2 - Disbale include date and time in filenames"
defaults write com.apple.screencapture include-date -bool false

echo.Green "3 - Disbale iclude shadow"
defaults write com.apple.screencapture disable-shadow -bool true

echo.Green "4 - Disable show thumbnail after screenshot"
defaults write com.apple.screencapture show-thumbnail -bool false

echo.Green "5 - Set default location to Pictures/Screenshots"
defaults write com.apple.screencapture location -string $HOME/Pictures/Screenshots

killall SystemUIServer

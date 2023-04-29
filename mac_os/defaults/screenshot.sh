#!/usr/bin/env bash

echo.Yellow "1 - Set default image format to jpg"
defaults write com.apple.screencapture type -string jpg

echo.Yellow "2 - Disbale include date and time in filenames"
defaults write com.apple.screencapture include-date -bool false

echo.Yellow "3 - Disbale iclude shadow"
defaults write com.apple.screencapture disable-shadow -bool true

echo.Yellow "4 - Disable show thumbnail after screenshot"
defaults write com.apple.screencapture show-thumbnail -bool false

echo.Yellow "5 - Set default location to Pictures/Screenshots"
defaults write com.apple.screencapture location -string $HOME/Pictures/Screenshots

killall SystemUIServer

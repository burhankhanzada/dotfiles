#!/usr/bin/env bash

echo.Green "1 - Reset launchpad"
defaults write com.apple.Dock ResetLaunchPad -bool true

echo.Green "2 - Change row and column size"
defaults write com.apple.dock springboard-rows -int 6
defaults write com.apple.dock springboard-columns -int 8

killall Dock

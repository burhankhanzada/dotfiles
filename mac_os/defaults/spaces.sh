#!/usr/bin/env bash

echo.Green "1 - Disable automatically rearrange"
defaults write com.apple.dock mru-spaces -bool false

killall Dock

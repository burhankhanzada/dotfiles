#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Hide all icons"
defaults write com.apple.finder CreateDesktop -bool false

echo.Green "2 - Hide removable media"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo.Green "3 - Hide external disks"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

killall Finder 2>/dev/null || true

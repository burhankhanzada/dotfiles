#!/usr/bin/env bash

echo.Green "1 - Hide all icons"
defaults write com.apple.finder CreateDesktop -bool false

echo.Green "2 - Hide removeable media"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo.Green "3 - Hide external disks"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

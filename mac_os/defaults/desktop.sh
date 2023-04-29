#!/usr/bin/env bash

echo.Yellow "1 - Hide all icons"
defaults write com.apple.finder CreateDesktop -bool false

echo.Yellow "2 - Hide removeable media"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo.Yellow "3 - Hide external disks"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

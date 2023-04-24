#!/usr/bin/env bash

echo "1 - Hide all icons"
defaults write com.apple.finder CreateDesktop -bool false

echo "2 - Hide removeable media"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo "3 - Hide external disks"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

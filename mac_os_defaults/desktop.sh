#!/usr/bin/env bash

# Hide all icons
defaults write com.apple.finder CreateDesktop -bool false

# Hide removable media
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Hide external disks
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

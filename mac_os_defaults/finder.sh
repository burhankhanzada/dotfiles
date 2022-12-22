#!/usr/bin/env bash

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Show tab bar
defaults write com.apple.finder ShowTabBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Display "Quit" option
defaults write com.apple.finder QuitMenuItem -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show hidden files inside
defaults write com.apple.finder AppleShowAllFiles -bool true

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set default view to column view
defaults write com.apple.finder FXPreferredViewStyle -string Clmv

# Set the default search scope to current folder
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

killall Finder

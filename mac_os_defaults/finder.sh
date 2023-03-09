#!/usr/bin/env bash

# echo "1 - Show the ~/Library folder"
# chflags nohidden ~/Library

# echo "2 - Show the /Volumes folder"
# sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

echo "3 - Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "4 - Show tab bar"
defaults write com.apple.finder ShowTabBar -bool true

echo "5 - Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "6 - Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "7 - Show quit option"
defaults write com.apple.finder QuitMenuItem -bool true

echo "8 - Set home as default location for new windows"
defaults write com.apple.finder NewWindowTarget -string "PfLo"

echo "9 - Disable warning before empty the trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "10 - Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "11 - Set keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "12 - Set default view to column view"
defaults write com.apple.finder FXPreferredViewStyle -string clmv

defaults write com.apple.finder FXPreferredSearchViewStyle -string clmv

echo "13 - Set the default search scope to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

echo "14 - Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "15 - Show file extensions"
defaults write -g AppleShowAllExtensions -bool true

echo "16 - Disbale creating .DS_Store files on network & USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "17 - Set expand save panel"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

killall Finder

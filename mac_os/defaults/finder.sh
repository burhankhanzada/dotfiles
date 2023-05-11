#!/usr/bin/env bash

echo.Green "1 - Show the /Volumes folder"
sudo chflags nohidden /Volumes

echo.Green "2 - Show file extensions"
defaults write -g AppleShowAllExtensions -bool true

echo.Green "3 - Show tab bar"
defaults write com.apple.finder ShowTabBar -bool true

echo.Green "4 - Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo.Green "5 - Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo.Green "6 - Disable empty tarch sound"
defaults write com.apple.Finder FinderSounds -bool false

echo.Green "7 - Show quit option"
defaults write com.apple.finder QuitMenuItem -bool true

echo.Green "8 - Set home as default location for new windows"
defaults write com.apple.finder NewWindowTarget -string PfLo

echo.Green "9 - Disable warning before empty the trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo.Green "10 - Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo.Green "11 - Set keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo.Green "12 - Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo.Green "13 - Set the default search scope to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

echo.Green "14 - Set default view to column view"
defaults write com.apple.finder FXPreferredViewStyle -string clmv
defaults write com.apple.finder FXPreferredSearchViewStyle -string clmv

echo.Green "15 - Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo.Green "16 - Make sort by name"
defaults write com.apple.finder.StandardViewSettings.IconViewSettings arrangeBy -string name

echo.Green "17 - Set expand save panel"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

echo.Green "18 - Disbale creating .DS_Store files on network & USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo.Green "19 - Expand General, Open with, and Sharing & Permissions Panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

killall Finder

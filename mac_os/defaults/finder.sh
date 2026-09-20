#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

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

echo.Green "6 - Disable empty trash sound"
defaults write com.apple.Finder FinderSounds -bool false

echo.Green "7 - Show quit option"
defaults write com.apple.finder QuitMenuItem -bool true

echo.Green "8 - Set home as default location for new windows"
defaults write com.apple.finder NewWindowTarget -string PfLo

echo.Green "9 - Disable warning before emptying the trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo.Green "10 - Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo.Green "11 - Set keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo.Green "12 - Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo.Green "13 - Set the default search scope to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

echo.Green "14 - Set default view to icon view"
defaults write com.apple.finder FXPreferredViewStyle -string icnv
defaults write com.apple.finder FXPreferredSearchViewStyle -string icnv

echo.Green "15 - Set default sort by name"
defaults write com.apple.finder FXPreferredGroupBy -string None
defaults write com.apple.finder FXPreferredSortOrder -string name

echo.Green "16 - Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo.Green "17 - Make sort by name"
defaults write com.apple.finder.StandardViewSettings.IconViewSettings arrangeBy -string name

echo.Green "18 - Set expand save panel"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

echo.Green "19 - Disable creating .DS_Store files on network & USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo.Green "20 - Expand General, Open with, and Sharing & Permissions Panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

echo.Green "21 - Clean sidebar"
defaults write com.apple.finder SidebarWidth -int 160
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool false
defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool false

killall Finder 2>/dev/null || true

#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "==> Configuring Finder & Desktop Defaults"

# --- Desktop Icons ---
echo.Green "Hide all desktop icons"
defaults write com.apple.finder CreateDesktop -bool false

echo.Green "Hide removable media from desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo.Green "Hide external disks from desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# --- Volumes & Paths ---
echo.Green "Show the /Volumes folder"
sudo chflags nohidden /Volumes 2>/dev/null || true

echo.Green "Show file extensions"
defaults write -g AppleShowAllExtensions -bool true

echo.Green "Show tab bar"
defaults write com.apple.finder ShowTabBar -bool true

echo.Green "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo.Green "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

# --- Finder Behavior ---
echo.Green "Disable empty trash sound"
defaults write com.apple.Finder FinderSounds -bool false

echo.Green "Show quit option in Finder menu"
defaults write com.apple.finder QuitMenuItem -bool true

echo.Green "Set home as default location for new windows"
defaults write com.apple.finder NewWindowTarget -string PfLo

echo.Green "Disable warning before emptying the trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo.Green "Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo.Green "Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo.Green "Disable the 'Are you sure you want to open this application?' quarantine dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo.Green "Set default search scope to current folder"
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

echo.Green "Set default view to icon view"
defaults write com.apple.finder FXPreferredViewStyle -string icnv
defaults write com.apple.finder FXPreferredSearchViewStyle -string icnv

echo.Green "Set default sort by name"
defaults write com.apple.finder FXPreferredGroupBy -string None
defaults write com.apple.finder FXPreferredSortOrder -string name

echo.Green "Disable warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo.Green "Make icon view sort by name"
defaults write com.apple.finder.StandardViewSettings.IconViewSettings arrangeBy -string name

# --- Save & Open Panels ---
echo.Green "Expand save panel by default"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# --- External Media & Sidebar ---
echo.Green "Disable creating .DS_Store files on network & USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo.Green "Expand General, Open with, and Sharing & Permissions panes"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

echo.Green "Configure clean sidebar"
defaults write com.apple.finder SidebarWidth -int 160
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool false
defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool false

echo.Green "Restarting Finder to apply changes"
killall Finder 2>/dev/null || true

#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "==> Configuring System, Screenshots & Diagnostics Defaults"

# --- Screenshots ---
echo.Green "Set screenshot format to JPG"
defaults write com.apple.screencapture type -string jpg

echo.Green "Disable date and time in screenshot filenames"
defaults write com.apple.screencapture include-date -bool false

echo.Green "Disable window shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo.Green "Disable floating thumbnail after screenshot"
defaults write com.apple.screencapture show-thumbnail -bool false

echo.Green "Set screenshot destination to Pictures/Screenshots"
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"

# --- Disk Utility ---
echo.Green "Show all devices in Disk Utility sidebar"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true

# --- Diagnostics & Metal HUD ---
echo.Green "Enable Metal HUD overlay for graphics performance"
defaults write -g MetalForceHudEnabled -bool true

# --- Apply System UI Changes ---
echo.Green "Restarting SystemUIServer to apply changes"
killall SystemUIServer 2>/dev/null || true

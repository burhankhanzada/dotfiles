#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "==> Configuring Hardware, Input & Power Defaults"

# --- Keyboard ---
echo.Green "Set fast keyboard repeat rate"
defaults write -g KeyRepeat -int 3
defaults write -g InitialKeyRepeat -int 12

echo.Green "Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo.Green "Disable automatic capitalization"
defaults write -g NSAutomaticCapitalizationEnabled -bool false

echo.Green "Disable input source shortcuts (Cmd+Space / Ctrl+Space conflicts)"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><false/></dict>'

echo.Green "Make fn key toggle input source"
defaults write com.apple.HIToolbox AppleFnUsageType -int 1

# --- Trackpad ---
echo.Green "Enable tap to click on trackpad"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo.Green "Enable 3-finger dragging"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo.Green "Disable 3-finger swipe gestures"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0

echo.Green "Disable sensitive backswipe on Chrome trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# --- Sound & Startup Chime ---
echo.Green "Mute startup sound / chime"
sudo nvram StartupMute=%01 2>/dev/null || true

# --- Display ---
echo.Green "Show resolutions as dropdown list"
defaults write com.apple.preference.displays display -bool true

# --- Sleep & Power Management ---
echo.Green "Configure system sleep and display timeout"
sudo pmset -a disablesleep 0 2>/dev/null || true
sudo pmset -b displaysleep 15 2>/dev/null || true
sudo pmset -c displaysleep 30 2>/dev/null || true

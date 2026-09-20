#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Enable tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo.Green "2 - Enable 3 Finger Dragging"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo.Green "3 - Disable three finger gesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0

echo.Green "4 - Disable the all too sensitive backswipe on trackpads on Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

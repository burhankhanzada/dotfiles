#!/usr/bin/env bash

echo.Green "1 - Enable tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

echo.Green "2 - Enable 3 Finger Dragging"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo.Green "3 - Disbale three finger gesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0

echo.Green "4 - Disable the all too sensitive backswipe on trackpads on Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

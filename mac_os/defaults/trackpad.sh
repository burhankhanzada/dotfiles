#!/usr/bin/env bash

echo.Yellow "1 - Enable tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

echo.Yellow "2 - Enable 3 Finger Dragging"
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true

echo.Yellow "3 - Enable 3 Finger Gesture For Mission Control & AppExpose"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0

echo.Yellow "4 - Disable the all too sensitive backswipe on trackpads on Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

#!/usr/bin/env bash

echo '1 - Enable tap to click'
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

echo '2 - Disable the all too sensitive backswipe on trackpads'
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

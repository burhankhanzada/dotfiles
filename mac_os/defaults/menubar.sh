#!/usr/bin/env bash

echo "1 - Hide spotlight icon from menu bar"
defaults write com.apple.Spotlight MenuItemHidden -bool true

echo "2 - HShow battery percentage"
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

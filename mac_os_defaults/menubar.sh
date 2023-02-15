#!/usr/bin/env bash

# Hide spotlight icon from menu bar
defaults write com.apple.Spotlight MenuItemHidden -bool true

# Show battery percentage
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

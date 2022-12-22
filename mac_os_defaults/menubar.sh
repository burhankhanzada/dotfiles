#!/usr/bin/env bash

# Hide spotlight icon from menu bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true

# Show battery percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

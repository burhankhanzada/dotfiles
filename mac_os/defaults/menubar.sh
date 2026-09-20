#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Hide spotlight icon from menu bar"
defaults write com.apple.Spotlight MenuItemHidden -bool true

echo.Green "2 - Show battery percentage"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

echo.Green "3 - Hide Text input menu"
defaults write com.apple.TextInputMenu visible -bool false

killall ControlCenter 2>/dev/null || true

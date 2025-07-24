#!/usr/bin/env bash

echo.Green "1 - Hide spotlight icon from menu bar"
defaults write com.apple.Spotlight MenuItemHidden -bool true

echo.Green "2 - Show battery percentage"
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

echo.Green "3 - Hide Text input menu"
defaults write com.apple.TextInputMenu visible -bool false

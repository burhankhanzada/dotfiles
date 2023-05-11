#!/usr/bin/env bash

echo.Green "1 - Set a fast keyboard repeat rate"
defaults write -g KeyRepeat -int 3
defaults write -g InitialKeyRepeat -int 12

echo.Green "2 - Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo.Green "3 - Disable automatic capitalization"
defaults write -g NSAutomaticCapitalizationEnabled -bool false

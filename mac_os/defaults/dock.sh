#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Set position to left"
defaults write com.apple.dock orientation -string left

echo.Green "2 - Set tile icon size to 35"
defaults write com.apple.dock tilesize -int 35

echo.Green "3 - Set large icon size to 50"
defaults write com.apple.dock largesize -int 50

echo.Green "4 - Enable magnification"
defaults write com.apple.dock magnification -bool true

echo.Green "5 - Disable recent apps"
defaults write com.apple.dock show-recents -bool false

echo.Green "6 - Show only open applications in Dock"
defaults write com.apple.dock static-only -bool true

echo.Green "7 - Enable minimize apps into icon"
defaults write com.apple.dock minimize-to-application -bool true

echo.Green "8 - Use scale effect for window minimization"
defaults write com.apple.dock mineffect -string scale

echo.Green "9 - Dim hidden application icons"
defaults write com.apple.dock showhidden -bool true

echo.Green "10 - Reset dock to remove persistent apps"
defaults write com.apple.dock persistent-apps -array

killall Dock 2>/dev/null || true

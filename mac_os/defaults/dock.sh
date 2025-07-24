#!/usr/bin/env bash

echo.Green "1 - Set tile icon size to 25"
defaults write com.apple.dock tilesize -int 35

echo.Green "2 - Set large icon size to 50"
defaults write com.apple.dock largesize -int 50

echo.Green "3 - Enable magnification"
defaults write com.apple.dock magnification -bool true

echo.Green "4 - Disable recents apps"
defaults write com.apple.dock show-recents -bool false

echo.Green "5 - Set position to left"
defaults write com.apple.dock "orientation" -string left

echo.Green "6 - Enable minimize apps into icon"
defaults write com.apple.dock minimize-to-application -bool true

echo.Green "7 - Reset dock to remove ? icons"
defaults write com.apple.dock persistent-apps -array

killall Dock

#!/usr/bin/env bash

echo "1 - Autohide when the mouse is out"
defaults write com.apple.dock autohide -bool true

echo "2 - Set tile icon size to 25"
defaults write com.apple.dock tilesize -int 25

echo "3 - Set large icon size to 50"
defaults write com.apple.dock largesize -int 50

echo "4 - Disable automatically rearrange spaces based on use"
defaults write com.apple.dock mru-spaces -bool false

echo "5 - Enable magnification"
defaults write com.apple.dock magnification -bool true

echo "6 - Disable recents apps"
defaults write com.apple.dock show-recents -bool false

echo "7 - Enable minimize apps into icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "8 - Enable minimize apps into icon"
defaults write com.apple.Dock ResetLaunchPad -bool true

killall Dock

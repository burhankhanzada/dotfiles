#!/usr/bin/env bash

source $MAC_OS_PATH/functions/dock/dock.sh

echo.Yellow "1 - Set tile icon size to 25"
defaults write com.apple.dock tilesize -int 25

echo.Yellow "2 - Set large icon size to 50"
defaults write com.apple.dock largesize -int 50

echo.Yellow "3 - Disable automatically rearrange spaces based on use"
defaults write com.apple.dock mru-spaces -bool false

echo.Yellow "4 - Enable magnification"
defaults write com.apple.dock magnification -bool true

echo.Yellow "5 - Disable recents apps"
defaults write com.apple.dock show-recents -bool false

echo.Yellow "6 - Enable minimize apps into icon"
defaults write com.apple.dock minimize-to-application -bool true

echo.Yellow "7 - Enable minimize apps into icon"
defaults write com.apple.Dock ResetLaunchPad -bool true

echo.Yellow "8 - Enable App Expose Genture"
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

echo.Yellow "9 - Enable Mission Control Genture"
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

killall Dock

#!/usr/bin/env bash

echo
echo.Blue "Running $DOTFILES/mac_os/reset_defaults.sh"

# echo.Yellow "1 - Delete com.apple.dock"
# defaults delete com.apple.dock

echo.Yellow "2 - Delete com.apple.finder"
defaults delete com.apple.finder

echo.Yellow "3 - Delete com.apple.Spotlight"
defaults delete com.apple.Spotlight

echo.Yellow "4 - Delete com.apple.controlcenter"
defaults delete com.apple.controlcenter

echo.Yellow "5 - Delete com.apple.screencapture"
defaults delete com.apple.screencapture

echo.Yellow "6 - Delete com.apple.LaunchServices"
defaults delete com.apple.LaunchServices

echo.Yellow "7 - Delete com.apple.desktopservices"
defaults delete com.apple.desktopservices

echo.Yellow "8 - Delete com.apple.AppleMultitouchTrackpad"
defaults delete com.apple.AppleMultitouchTrackpad

echo.Yellow "9 - Delete KeyRepeat"
defaults delete -g KeyRepeat

echo.Yellow "10 - Delete InitialKeyRepeat"
defaults delete -g InitialKeyRepeat

echo.Yellow "11 - Delete AppleShowAllExtensions"
defaults delete -g AppleShowAllExtensions

echo.Yellow "12 - Delete ApplePressAndHoldEnabled"
defaults delete -g ApplePressAndHoldEnabled

echo.Yellow "13 - Delete NSAutomaticCapitalizationEnabled"
defaults delete -g NSAutomaticCapitalizationEnabled

echo.Yellow "14 - Delete NSNavPanelExpandedStateForSaveMode"
defaults delete -g NSNavPanelExpandedStateForSaveMode

echo.Yellow "15 - Delete NSNavPanelExpandedStateForSaveMode2"
defaults delete -g NSNavPanelExpandedStateForSaveMode2

killall Dock
killall Finder

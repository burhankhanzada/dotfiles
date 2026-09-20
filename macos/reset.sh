#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

echo.Blue "Running $DOTFILES/macos/reset.sh"

echo.Yellow "1 - Delete com.apple.dock"
defaults delete com.apple.dock 2>/dev/null || true

echo.Yellow "2 - Delete com.apple.finder"
defaults delete com.apple.finder 2>/dev/null || true

echo.Yellow "3 - Delete com.apple.Spotlight"
defaults delete com.apple.Spotlight 2>/dev/null || true

echo.Yellow "4 - Delete com.apple.controlcenter"
defaults delete com.apple.controlcenter 2>/dev/null || true

echo.Yellow "5 - Delete com.apple.screencapture"
defaults delete com.apple.screencapture 2>/dev/null || true

echo.Yellow "6 - Delete com.apple.LaunchServices"
defaults delete com.apple.LaunchServices 2>/dev/null || true

echo.Yellow "7 - Delete com.apple.desktopservices"
defaults delete com.apple.desktopservices 2>/dev/null || true

echo.Yellow "8 - Delete com.apple.symbolichotkeys"
defaults delete com.apple.symbolichotkeys 2>/dev/null || true

echo.Yellow "9 - Delete com.apple.AppleMultitouchTrackpad"
defaults delete com.apple.AppleMultitouchTrackpad 2>/dev/null || true

echo.Yellow "10 - Delete KeyRepeat"
defaults delete -g KeyRepeat 2>/dev/null || true

echo.Yellow "11 - Delete InitialKeyRepeat"
defaults delete -g InitialKeyRepeat 2>/dev/null || true

echo.Yellow "12 - Delete AppleShowAllExtensions"
defaults delete -g AppleShowAllExtensions 2>/dev/null || true

echo.Yellow "13 - Delete ApplePressAndHoldEnabled"
defaults delete -g ApplePressAndHoldEnabled 2>/dev/null || true

echo.Yellow "14 - Delete NSAutomaticCapitalizationEnabled"
defaults delete -g NSAutomaticCapitalizationEnabled 2>/dev/null || true

echo.Yellow "15 - Delete NSNavPanelExpandedStateForSaveMode"
defaults delete -g NSNavPanelExpandedStateForSaveMode 2>/dev/null || true

echo.Yellow "16 - Delete NSNavPanelExpandedStateForSaveMode2"
defaults delete -g NSNavPanelExpandedStateForSaveMode2 2>/dev/null || true

echo.Blue "Restarting services to apply default resets..."
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
killall ControlCenter 2>/dev/null || true

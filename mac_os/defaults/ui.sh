#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "==> Configuring UI & Appearance Defaults"

# --- Theme & Animations ---
echo.Green "Set dark theme"
defaults write -g AppleInterfaceStyle -string Dark

echo.Green "Reduce animations"
defaults write com.apple.Accessibility ReduceMotionEnabled -bool true

# --- Dock ---
echo.Green "Set Dock position to left"
defaults write com.apple.dock orientation -string left

echo.Green "Set Dock tile icon size to 35"
defaults write com.apple.dock tilesize -int 35

echo.Green "Set Dock large icon size to 50"
defaults write com.apple.dock largesize -int 50

echo.Green "Enable Dock magnification"
defaults write com.apple.dock magnification -bool true

echo.Green "Disable recent applications section in Dock"
defaults write com.apple.dock show-recents -bool false

echo.Green "Show only open applications in Dock"
defaults write com.apple.dock static-only -bool true

echo.Green "Minimize applications into their icon"
defaults write com.apple.dock minimize-to-application -bool true

echo.Green "Use scale effect for window minimization"
defaults write com.apple.dock mineffect -string scale

echo.Green "Dim hidden application icons (Cmd + H)"
defaults write com.apple.dock showhidden -bool true

echo.Green "Reset dock persistent apps"
defaults write com.apple.dock persistent-apps -array

# --- Spaces & Mission Control ---
echo.Green "Disable automatically rearrange Spaces"
defaults write com.apple.dock mru-spaces -bool false

echo.Green "Enable App Expose gesture"
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

echo.Green "Enable Mission Control gesture"
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

# --- Launchpad ---
echo.Green "Reset Launchpad layout"
defaults write com.apple.Dock ResetLaunchPad -bool true

echo.Green "Set Launchpad grid to 6 rows and 8 columns"
defaults write com.apple.dock springboard-rows -int 6
defaults write com.apple.dock springboard-columns -int 8

# --- Menu Bar & Control Center ---
echo.Green "Hide Spotlight icon from menu bar"
defaults write com.apple.Spotlight MenuItemHidden -bool true

echo.Green "Show battery percentage in menu bar"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

echo.Green "Hide text input menu"
defaults write com.apple.TextInputMenu visible -bool false

# --- Apply UI Changes ---
echo.Green "Restarting Dock and ControlCenter to apply changes"
killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true

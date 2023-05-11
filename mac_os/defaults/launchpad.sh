#!/usr/bin/env bash

echo.Green "1 - Reset launchpad"
defaults write com.apple.Dock ResetLaunchPad -bool true

killall Dock

#!/usr/bin/env bash

echo.Green "1 - Enable app expose gesture"
defaults write com.apple.dock showAppExposeGestureEnabled -bool true

echo.Green "2 - Enable mission control gesture"
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

killall Dock
#!/usr/bin/env bash

echo.Green "1 - Reduce animations"
defaults write com.apple.Accessibility ReduceMotionEnabled -bool true

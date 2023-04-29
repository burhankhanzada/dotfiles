#!/usr/bin/env bash

echo.Yellow "1 - Reduce animations"
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

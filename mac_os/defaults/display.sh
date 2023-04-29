#!/usr/bin/env bash

echo.Yellow "1 - Show resolutions as dropdown list"
defaults write com.apple.Displays-Settings.extension showListByDefault -bool true

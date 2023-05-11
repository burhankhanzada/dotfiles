#!/usr/bin/env bash

echo.Green "1 - Show resolutions as dropdown list"
defaults write com.apple.Displays-Settings.extension showListByDefault -bool true

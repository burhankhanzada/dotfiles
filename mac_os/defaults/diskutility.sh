#!/usr/bin/env bash

echo.Green "1 - Show all devices"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true

#!/usr/bin/env bash

defaults delete com.apple.dock
defaults delete com.apple.finder
defaults delete com.apple.Spotlight
defaults delete com.apple.controlcenter
defaults delete com.apple.screencapture
defaults delete com.apple.LaunchServices
defaults delete com.apple.desktopservices
defaults delete com.apple.AppleMultitouchTrackpad

defaults delete -g KeyRepeat
defaults delete -g InitialKeyRepeat
defaults delete -g AppleShowAllExtensions
defaults delete -g ApplePressAndHoldEnabled
defaults delete -g NSAutomaticCapitalizationEnabled
defaults delete -g NSNavPanelExpandedStateForSaveMode
defaults delete -g NSNavPanelExpandedStateForSaveMode2

killall Dock
killall Finder

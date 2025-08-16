#!/usr/bin/env bash

echo.Green "1 - Set a fast keyboard repeat rate"
defaults write -g KeyRepeat -int 3
defaults write -g InitialKeyRepeat -int 12

echo.Green "2 - Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo.Green "3 - Disable automatic capitalization"
defaults write -g NSAutomaticCapitalizationEnabled -bool false

echo.Green "4 - Disable previous input source shorcut"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 '<dict><key>enabled</key><false/></dict>'

echo.Green "5 - Disable next input source shorcut" 
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><false/></dict>'

echo.Green "5 - Make fn to change input source" 
deffaults write com.apple.HIToolbox AppleFnUsageType --int 1

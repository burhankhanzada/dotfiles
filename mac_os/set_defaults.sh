#!/usr/bin/env bash

source $HOME/.zprofile

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

for file in "$DOTFILES/mac_os/defaults/"*; do

    file_name=$(basename $file)

    continueAbortSourceFile "Run $file_name?" $file
done

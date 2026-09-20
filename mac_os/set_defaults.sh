#!/usr/bin/env bash

source $HOME/.zprofile

# Close any open System Preferences or System Settings panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

for file in "$DOTFILES/mac_os/defaults/"*.sh; do
    [ -f "$file" ] || continue

    file_name=$(basename "$file")

    continueAbortSourceFile "Run $file_name?" "$file"
done

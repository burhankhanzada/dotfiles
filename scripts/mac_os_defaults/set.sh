#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

for file in "$DOTFILES/mac_os_defaults/"*; do

    echo ""
    echo "Running $file"

    # calling script as part of this script process so no need to make them executable
    # shellcheck source=/dev/null
    source $file
done

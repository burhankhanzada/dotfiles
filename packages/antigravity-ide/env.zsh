#!/usr/bin/env zsh
# Antigravity IDE CLI binary path configuration.

app_bin="/Applications/Antigravity IDE.app/Contents/Resources/app/bin"
if [ -d "$app_bin" ]; then
    export PATH="$app_bin:$PATH"
fi

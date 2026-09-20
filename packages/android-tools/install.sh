#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

# Install standalone Android Agent CLI (https://developer.android.com/tools/agents)
continueAbortCommand "brew install --cask android-cli"

# Install standalone Android Platform Tools (adb, fastboot)
continueAbortCommand "brew install --cask android-platform-tools"

# Initialize Android CLI environment and agent skills
if command -v android &>/dev/null; then
    echo
    echo.Blue "Initializing Android CLI environment and agent skills..."
    android init || true
fi

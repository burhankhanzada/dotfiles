#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

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

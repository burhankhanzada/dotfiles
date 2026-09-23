#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

# If standalone android-cli cask was previously installed, remove it to avoid
# binary symlink collision with android-commandlinetools (which bundles android CLI)
if brew list --cask android-cli &>/dev/null; then
    echo.Blue "Removing legacy android-cli cask to prevent binary conflicts with android-commandlinetools..."
    brew uninstall --cask android-cli
fi

# Install standalone Android Platform Tools (adb, fastboot)
# https://developer.android.com/tools/releases/platform-tools
continueAbortCommand "brew install --cask android-platform-tools"

# Install Android Command-line Tools (includes android CLI, avdmanager, sdkmanager)
# https://developer.android.com/tools/avdmanager
# https://developer.android.com/tools/sdkmanager
continueAbortCommand "brew install --cask android-commandlinetools"

# Initialize Android CLI environment and agent skills
if command -v android &>/dev/null; then
    echo
    echo.Blue "Initializing Android CLI environment and agent skills..."
    android init || true
fi

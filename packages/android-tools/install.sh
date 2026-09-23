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
continueAbortCommand "brew install --cask android-platform-tools"

# Install Android Command-line Tools (includes android CLI, avdmanager, sdkmanager)
continueAbortCommand "brew install --cask android-commandlinetools"

# Automatically accept Android SDK licenses
if command -v sdkmanager &>/dev/null; then
    echo
    echo.Blue "Accepting Android SDK licenses..."
    yes | sdkmanager --licenses &>/dev/null || true
fi

# Pre-generate shell completion cache for fast terminal startup
if command -v android &>/dev/null; then
    android_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/android"
    mkdir -p "$android_cache_dir" 2>/dev/null
    android completion zsh > "$android_cache_dir/completion.zsh" 2>/dev/null || true
fi

# Initialize Android CLI environment and agent skills
if command -v android &>/dev/null; then
    echo
    echo.Blue "Initializing Android CLI environment and agent skills..."
    android init || true
fi

# Optional Android Emulator & default ARM64 system image setup
sdk_root="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
if command -v sdkmanager &>/dev/null && [ ! -d "$sdk_root/emulator" ]; then
    echo
    echo.Blue "Android emulator is not installed yet."
    continueAbortCommand "sdkmanager 'emulator' 'platform-tools' 'platforms;android-34' 'system-images;android-34;google_apis;arm64-v8a'"
fi

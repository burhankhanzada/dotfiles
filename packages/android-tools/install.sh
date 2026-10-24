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

# sdkmanager derives its SDK root from its own (symlink-resolved) location, i.e. the
# Homebrew prefix, so always pass --sdk_root to keep packages inside ANDROID_HOME
sdk_root="${ANDROID_HOME:-$HOME/Library/Android/sdk}"

# Automatically accept Android SDK licenses
if command -v sdkmanager &>/dev/null; then
    echo
    echo.Blue "Accepting Android SDK licenses..."
    yes | sdkmanager --sdk_root="$sdk_root" --licenses &>/dev/null || true
fi

# Pre-generate shell completion cache for fast terminal startup
if command -v android &>/dev/null; then
    android_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/android"
    mkdir -p "$android_cache_dir" 2>/dev/null
    # Strip the update notice the CLI prints on stdout
    android completion zsh 2>/dev/null \
        | sed -e '/^A new version of Android CLI/d' -e "/^Please run 'android update'/d" \
        > "$android_cache_dir/completion.zsh" || true
fi

# Initialize Android CLI environment and agent skills
if command -v android &>/dev/null; then
    echo
    echo.Blue "Initializing Android CLI environment and agent skills..."
    android init || true
fi

# Optional Android Emulator & default ARM64 system image setup
if command -v sdkmanager &>/dev/null && [ ! -d "$sdk_root/emulator" ]; then
    echo
    echo.Blue "Android emulator is not installed yet."
    continueAbortCommand "sdkmanager --sdk_root=\"$sdk_root\" 'emulator' 'platforms;android-34' 'platforms;android-36' 'build-tools;37.0.0' 'system-images;android-34;google_apis;arm64-v8a'"
fi

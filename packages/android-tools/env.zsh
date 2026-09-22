#!/usr/bin/env zsh
# Android CLI, ADB platform tools, avdmanager & sdkmanager environment configuration.

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
export ANDROID_USER_HOME="${ANDROID_USER_HOME:-$HOME/.android}"

if [ -d "$ANDROID_HOME" ]; then
    # Add Android SDK platform tools, cmdline-tools (avdmanager, sdkmanager), and emulator to PATH
    [ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
    [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    [ -d "$ANDROID_HOME/tools/bin" ] && export PATH="$ANDROID_HOME/tools/bin:$PATH"
    [ -d "$ANDROID_HOME/emulator" ] && export PATH="$ANDROID_HOME/emulator:$PATH"
fi

# Fallback for standalone Homebrew android-commandlinetools installation
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
if [ -d "$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin" ]; then
    export PATH="$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin:$PATH"
fi

# Shell completion for android CLI if available
if [ -n "$ZSH_VERSION" ] && type compdef &>/dev/null && command -v android &>/dev/null; then
    eval "$(android completion zsh 2>/dev/null)"
fi

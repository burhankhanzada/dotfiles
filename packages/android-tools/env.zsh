#!/usr/bin/env zsh
# Android CLI & ADB platform tools environment configuration.

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_USER_HOME="${ANDROID_USER_HOME:-$HOME/.android}"

if [ -d "$ANDROID_HOME" ]; then
    # Add Android SDK platform tools and cmdline-tools to PATH
    [ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
    [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    [ -d "$ANDROID_HOME/tools" ] && export PATH="$ANDROID_HOME/tools:$PATH"
fi

# Shell completion for android CLI if available
if [ -n "$ZSH_VERSION" ] && type compdef &>/dev/null && command -v android &>/dev/null; then
    eval "$(android completion zsh 2>/dev/null)"
fi

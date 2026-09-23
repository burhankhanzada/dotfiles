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

    # Add latest installed build-tools (aapt, zipalign, apksigner) to PATH
    if [ -d "$ANDROID_HOME/build-tools" ]; then
        local -a btools=("$ANDROID_HOME"/build-tools/*(N/n[-1]))
        [ -n "${btools[1]}" ] && [ -d "${btools[1]}" ] && export PATH="${btools[1]}:$PATH"
    fi
fi

# Fallback for standalone Homebrew android-commandlinetools installation
BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
if [ -d "$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin" ]; then
    export PATH="$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin:$PATH"
fi

# Sync Android environment with macOS GUI applications (Antigravity IDE, VS Code, Studio)
if command -v launchctl &>/dev/null; then
    launchctl setenv ANDROID_HOME "$ANDROID_HOME" 2>/dev/null || true
    launchctl setenv ANDROID_SDK_ROOT "$ANDROID_SDK_ROOT" 2>/dev/null || true
    launchctl setenv ANDROID_USER_HOME "$ANDROID_USER_HOME" 2>/dev/null || true
fi

# Shell completion for android CLI if available (cached for sub-millisecond shell startup)
if [ -n "$ZSH_VERSION" ] && command -v android &>/dev/null; then
    android_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/android"
    android_comp_file="$android_cache_dir/completion.zsh"
    android_bin="${commands[android]:-$(command -v android 2>/dev/null)}"

    # Regenerate cache only if file is missing or binary is newer
    if [ ! -s "$android_comp_file" ] || ([ -n "$android_bin" ] && [ "$android_bin" -nt "$android_comp_file" ]); then
        mkdir -p "$android_cache_dir" 2>/dev/null
        android completion zsh > "$android_comp_file" 2>/dev/null
    fi

    if (( $+functions[compdef] )) || type compdef &>/dev/null; then
        [ -s "$android_comp_file" ] && source "$android_comp_file"
    fi
fi

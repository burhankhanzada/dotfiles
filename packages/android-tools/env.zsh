#!/usr/bin/env zsh
# Android CLI, ADB platform tools, avdmanager & sdkmanager environment configuration.

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
export ANDROID_USER_HOME="${ANDROID_USER_HOME:-$HOME/.android}"

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

# Re-point platform-tools at the current cask version once `brew upgrade` removes the old one
if [ -L "$ANDROID_HOME/platform-tools" ] && [ ! -e "$ANDROID_HOME/platform-tools" ]; then
    latest_ptools=$(ls -d "$BREW_PREFIX"/Caskroom/android-platform-tools/*/platform-tools 2>/dev/null | sort -V | tail -n 1)
    [ -n "$latest_ptools" ] && ln -sfn "$latest_ptools" "$ANDROID_HOME/platform-tools"
fi

if [ -d "$ANDROID_HOME" ]; then
    # Add Android SDK platform tools, cmdline-tools (avdmanager, sdkmanager), and emulator to PATH
    [ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
    [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    [ -d "$ANDROID_HOME/tools/bin" ] && export PATH="$ANDROID_HOME/tools/bin:$PATH"
    [ -d "$ANDROID_HOME/emulator" ] && export PATH="$ANDROID_HOME/emulator:$PATH"

    # Add latest installed build-tools (aapt, zipalign, apksigner) to PATH
    if [ -d "$ANDROID_HOME/build-tools" ]; then
        if [ -n "$ZSH_VERSION" ]; then
            eval 'local -a btools=("$ANDROID_HOME"/build-tools/*(N/n[-1])); [ -n "${btools[1]}" ] && [ -d "${btools[1]}" ] && export PATH="${btools[1]}:$PATH"'
        else
            latest_btools=$(find "$ANDROID_HOME/build-tools" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -V | tail -n 1)
            [ -n "$latest_btools" ] && [ -d "$latest_btools" ] && export PATH="$latest_btools:$PATH"
        fi
    fi
fi

# Fallback for standalone Homebrew android-commandlinetools installation
if [ -d "$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin" ]; then
    export PATH="$BREW_PREFIX/share/android-commandlinetools/cmdline-tools/latest/bin:$PATH"
fi

# Shell completion for android CLI if available (cached for sub-millisecond shell startup)
if [ -n "$ZSH_VERSION" ] && command -v android &>/dev/null; then
    android_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/android"
    android_comp_file="$android_cache_dir/completion.zsh"
    android_bin="${commands[android]:-$(command -v android 2>/dev/null)}"

    # Regenerate cache if missing, binary is newer, or a stale update notice leaked into it
    if [ ! -s "$android_comp_file" ] || ([ -n "$android_bin" ] && [ "$android_bin" -nt "$android_comp_file" ]) \
        || grep -q "^A new version of Android CLI" "$android_comp_file" 2>/dev/null; then
        mkdir -p "$android_cache_dir" 2>/dev/null
        # The CLI prints its update notice on stdout; strip it so it isn't sourced as code
        android completion zsh 2>/dev/null \
            | sed -e '/^A new version of Android CLI/d' -e "/^Please run 'android update'/d" > "$android_comp_file"
    fi

    if type compdef &>/dev/null; then
        [ -s "$android_comp_file" ] && source "$android_comp_file"
    fi
fi

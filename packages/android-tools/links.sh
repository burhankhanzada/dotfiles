#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

android="${DEVELOPMENT:-$HOME/Development}/Google/Android"
brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

if [ -d "${DEVELOPMENT:-$HOME/Development}" ]; then
    mkdir -p "$android/sdk"
    mkdir -p "$android/.android"
    mkdir -p "$android/.gradle"

    # Link Homebrew cmdline-tools into SDK root
    if [ -d "$brew_prefix/share/android-commandlinetools/cmdline-tools" ]; then
        symlink "$brew_prefix/share/android-commandlinetools/cmdline-tools" "$android/sdk/cmdline-tools"
    fi

    # Link Homebrew platform-tools into SDK root
    platform_tools_src=$(echo "$brew_prefix"/Caskroom/android-platform-tools/*/platform-tools | awk '{print $NF}')
    if [ -d "$platform_tools_src" ]; then
        symlink "$platform_tools_src" "$android/sdk/platform-tools"
    fi

    symlink "$android/.gradle" "$HOME/.gradle"
    symlink "$android/.android" "$HOME/.android"
    symlink "$android/sdk" "$HOME/Library/Android/sdk"
fi

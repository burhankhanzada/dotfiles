#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

android="${DEVELOPMENT:-$HOME/Development}/Google/Android"
brew_prefix="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

mkdir -p "$android/sdk"
mkdir -p "$android/.android"

# Link Homebrew cmdline-tools into SDK root
if [ -d "$brew_prefix/share/android-commandlinetools/cmdline-tools" ]; then
    symlink "$brew_prefix/share/android-commandlinetools/cmdline-tools" "$android/sdk/cmdline-tools"

    # sdkmanager run without --sdk_root (e.g. by `flutter doctor`) resolves to the Homebrew
    # prefix, so share the SDK's licenses there to keep a single accepted copy
    mkdir -p "$android/sdk/licenses"
    symlink "$android/sdk/licenses" "$brew_prefix/share/android-commandlinetools/licenses"
fi

# Link Homebrew platform-tools into SDK root
platform_tools_src=$(ls -d "$brew_prefix"/Caskroom/android-platform-tools/*/platform-tools 2>/dev/null | sort -V | tail -n 1)
if [ -d "$platform_tools_src" ]; then
    symlink "$platform_tools_src" "$android/sdk/platform-tools"
fi

symlink "$android/.android" "$HOME/.android"
symlink "$android/sdk" "$HOME/Library/Android/sdk"

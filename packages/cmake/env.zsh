#!/usr/bin/env zsh
# CMake and GNU make environment configuration.

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
if [ -d "$BREW_PREFIX/opt/make/libexec/gnubin" ]; then
    export PATH="$BREW_PREFIX/opt/make/libexec/gnubin:$PATH"
fi

#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

# Install Android Studio IDE GUI application
continueAbortCommand "brew install --cask android-studio"

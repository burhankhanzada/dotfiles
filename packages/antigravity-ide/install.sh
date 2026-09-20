#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

# Install Google Antigravity IDE (https://antigravity.google/product/antigravity-ide)
continueAbortCommand "brew install --cask antigravity-ide"

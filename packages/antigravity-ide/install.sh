#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

# Install Google Antigravity IDE (https://antigravity.google/product/antigravity-ide)
continueAbortCommand "brew install --cask antigravity-ide"

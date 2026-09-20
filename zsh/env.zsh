#!/usr/bin/env zsh
# Core environment variables.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PROJECTS="${PROJECTS:-$HOME/Projects}"
export DEVELOPMENT="${DEVELOPMENT:-$HOME/Development}"
export SECRETS="${SECRETS:-$DEVELOPMENT/Secrets}"

# Ensure Homebrew bin is in PATH early if installed
if [ -x "/opt/homebrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [ -x "/usr/local/bin/brew" ]; then
    export HOMEBREW_PREFIX="/usr/local"
fi

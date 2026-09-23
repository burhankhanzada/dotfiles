#!/usr/bin/env zsh
# Core environment variables.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PROJECTS="${PROJECTS:-$HOME/Projects}"
export DEVELOPMENT="${DEVELOPMENT:-$HOME/Development}"
export SECRETS="${SECRETS:-$DEVELOPMENT/Secrets}"

# Keep PATH, FPATH, and MANPATH arrays unique (prevent duplicate entries)
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH 2>/dev/null || true

# Ensure Homebrew bin is in PATH early if installed
if [ -x "/opt/homebrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    export HOMEBREW_PREFIX="/usr/local"
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Sync PATH with macOS GUI applications (Antigravity IDE, VS Code, Cursor)
if command -v launchctl &>/dev/null && [ -n "$HOMEBREW_PREFIX" ]; then
    launchctl setenv PATH "$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" 2>/dev/null || true
fi

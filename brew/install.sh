#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

# 1. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo.Blue "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo.Green "Homebrew is already installed"
fi

# 2. Detect Homebrew prefix (Apple Silicon vs Intel)
if [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
    BREW_BIN="/usr/local/bin/brew"
elif command -v brew &>/dev/null; then
    BREW_BIN="$(command -v brew)"
fi

# 3. Load brew shellenv in the current shell
if [ -n "$BREW_BIN" ]; then
    eval "$($BREW_BIN shellenv)"

    # Add to ~/.zprofile only if not already present
    if ! grep -qs "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
        echo.Blue "Adding Homebrew to ~/.zprofile..."
        (
            echo
            echo "eval \"\$($BREW_BIN shellenv)\""
        ) >> "$HOME/.zprofile"
    fi
fi

# 4. Install mas (Mac App Store CLI) if missing
if ! command -v mas &>/dev/null; then
    echo.Blue "Installing mas..."
    brew install mas
else
    echo.Green "mas is already installed"
fi

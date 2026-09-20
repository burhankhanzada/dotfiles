#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

# 1. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo.Blue "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo.Green "Homebrew is already installed"
fi

# 2. Detect Homebrew binary prefix
if [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
    BREW_BIN="/usr/local/bin/brew"
elif command -v brew &>/dev/null; then
    BREW_BIN="$(command -v brew)"
fi

# 3. Load brew shellenv in current shell
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

# 4. Configure optional symlinks if Development/Homebrew exists
if [ -d "$DEVELOPMENT/Homebrew" ]; then
    echo.Blue "Linking Homebrew custom directories..."
    command -v symlink &>/dev/null && symlink "$DEVELOPMENT/Homebrew/Caches/Homebrew" "$HOME/Library/Caches/Homebrew"
fi

# 5. Install all declared packages from Brewfile
if [ -f "$DOTFILES/Brewfile" ]; then
    echo.Blue "Installing packages from $DOTFILES/Brewfile..."
    brew bundle --file="$DOTFILES/Brewfile"
fi
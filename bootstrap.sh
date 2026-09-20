#!/usr/bin/env bash

# Resolve dotfiles root path dynamically
export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# Ask for administrator password upfront
sudo -v

# Keep-alive: update sudo timestamp until script exits, then terminate background process
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
SUDO_PID=$!
trap 'kill -TERM "$SUDO_PID" 2>/dev/null' EXIT

# Load helper functions early (colors, prompts, installers)
if [ -f "$DOTFILES/zsh/functions.sh" ]; then
    source "$DOTFILES/zsh/functions.sh"
fi

# Fallback echo helpers if not loaded
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

# 1. Ensure Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
    echo.Blue "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# 2. Setup Homebrew
echo.Blue "==> Running Homebrew setup"
source "$DOTFILES/brew/setup.sh"

# 3. Setup ZSH configuration
echo.Blue "==> Running ZSH setup"
source "$DOTFILES/zsh/setup.sh"

# 4. Setup macOS defaults
echo.Blue "==> Running macOS defaults"
source "$DOTFILES/mac_os/setup.sh"

# 5. Setup packages
echo.Blue "==> Running Packages setup"
source "$DOTFILES/packages/setup.sh"

echo.Green "==> Dotfiles bootstrap complete!"

#!/usr/bin/env bash

# Resolve dotfiles root path dynamically
export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# Load helper functions early (colors, prompts, installers)
if [ -f "$DOTFILES/zsh/functions.sh" ]; then
    source "$DOTFILES/zsh/functions.sh"
fi

# Fallback echo helpers if not loaded
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Blue '    ____        __  _____ __           '
echo.Blue '   / __ \____  / /_/ __(_) /__  _____  '
echo.Blue '  / / / / __ \/ __/ /_/ / / _ \/ ___/  '
echo.Blue ' / /_/ / /_/ / /_/ __/ / /  __(__  )   '
echo.Blue '/_____/\____/\__/_/ /_/_/\___/____/    '
echo.Blue '  Burhan Khanzada - Personal Dotfiles  '
echo

bootstrap_start=$(date +%s)

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

# 1. Ensure Xcode Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
    echo.Blue "==> [1/5] Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
else
    echo.Green "==> [1/5] Xcode Command Line Tools already installed"
fi

# 2. Setup Homebrew
echo.Blue "==> [2/5] Running Homebrew setup"
source "$DOTFILES/brew/setup.sh"

# 3. Setup ZSH configuration
echo.Blue "==> [3/5] Running ZSH setup"
source "$DOTFILES/zsh/setup.sh"

# 4. Setup macOS defaults
echo.Blue "==> [4/5] Running macOS defaults"
source "$DOTFILES/mac_os/setup.sh"

# 5. Setup packages (pass through any CLI flags like -y)
echo.Blue "==> [5/5] Running Packages setup"
source "$DOTFILES/packages/setup.sh" "$@"

bootstrap_end=$(date +%s)
bootstrap_duration=$((bootstrap_end - bootstrap_start))

echo
echo.Green "═══════════════════════════════════════════════════════"
echo.Green "  Dotfiles bootstrap completed in ${bootstrap_duration}s!              "
echo.Green "═══════════════════════════════════════════════════════"
echo

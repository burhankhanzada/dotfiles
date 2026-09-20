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
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }

echo.Blue '    ____        __  _____ __           '
echo.Blue '   / __ \____  / /_/ __(_) /__  _____  '
echo.Blue '  / / / / __ \/ __/ /_/ / / _ \/ ___/  '
echo.Blue ' / /_/ / /_/ / /_/ __/ / /  __(__  )   '
echo.Blue '/_____/\____/\__/_/ /_/_/\___/____/    '
echo.Blue '  Burhan Khanzada - Personal Dotfiles  '
echo

# Parse command line flags
AUTO_ALL=false
USE_TUI=true

for arg in "$@"; do
    case "$arg" in
        -y|--yes|--all)
            AUTO_ALL=true
            USE_TUI=false
            export AUTO_ALL=true
            ;;
        --no-tui)
            USE_TUI=false
            ;;
        -h|--help)
            echo "Usage: ./bootstrap.sh [OPTIONS]"
            echo
            echo "Options:"
            echo "  -y, --yes, --all    Install and configure everything non-interactively"
            echo "  --no-tui            Bypass interactive TUI wizard"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
    esac
done

# Launch interactive Claude Code-style 3-tab TUI wizard upfront if interactive
chosen_macos_defaults=()
chosen_packages=()

if [[ "$USE_TUI" == "true" ]] && [[ "$AUTO_ALL" != "true" ]] && [ -t 0 ] && command -v python3 &>/dev/null && [ -f "$DOTFILES/functions/tui_wizard.py" ]; then
    wizard_json=$(mktemp)
    trap 'rm -f "$wizard_json" 2>/dev/null' EXIT

    if python3 "$DOTFILES/functions/tui_wizard.py" --output "$wizard_json"; then
        if [ -f "$wizard_json" ] && [ -s "$wizard_json" ]; then
            # Parse selected items
            while IFS= read -r item; do
                [ -n "$item" ] && chosen_packages+=("$item")
            done < <(python3 -c "import json; data=json.load(open('$wizard_json')); print('\n'.join(data.get('packages', [])))")

            while IFS= read -r item; do
                [ -n "$item" ] && chosen_macos_defaults+=("$item")
            done < <(python3 -c "import json; data=json.load(open('$wizard_json')); print('\n'.join(data.get('macos', [])))")
        fi
    else
        echo
        echo.Red "==> Bootstrap cancelled by user."
        exit 0
    fi
    rm -f "$wizard_json"
fi

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
if [ ${#chosen_macos_defaults[@]} -gt 0 ]; then
    for cat in "${chosen_macos_defaults[@]}"; do
        script="$DOTFILES/mac_os/defaults/${cat}.sh"
        if [ -f "$script" ]; then
            echo.Blue "Applying macOS defaults category: $cat"
            source "$script"
        fi
    done
else
    source "$DOTFILES/mac_os/setup.sh"
fi

# 5. Setup packages
echo.Blue "==> [5/5] Running Packages setup"
if [ ${#chosen_packages[@]} -gt 0 ]; then
    # Run packages setup with pre-selected package list
    for pkg in "${chosen_packages[@]}"; do
        if [ -d "$DOTFILES/packages/$pkg" ]; then
            echo.Green "==> Setting up selected package: $pkg"
            installPackage "$pkg"
        fi
    done
else
    source "$DOTFILES/packages/setup.sh" "$@"
fi

bootstrap_end=$(date +%s)
bootstrap_duration=$((bootstrap_end - bootstrap_start))

echo
echo.Green "═══════════════════════════════════════════════════════"
echo.Green "  Dotfiles bootstrap completed in ${bootstrap_duration}s!              "
echo.Green "═══════════════════════════════════════════════════════"
echo

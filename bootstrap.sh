#!/usr/bin/env bash

# Resolve dotfiles root path dynamically
export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# Load helper functions early (colors, prompts, installers)
[ -f "$DOTFILES/core/init.sh" ] && source "$DOTFILES/core/init.sh"

echo.Blue '    ____        __  _____ __          '
echo.Blue '   / __ \____  / /_/ __(_) /__  _____ '
echo.Blue '  / / / / __ \/ __/ /_/ / / _ \/ ___/ '
echo.Blue ' / /_/ / /_/ / /_/ __/ / /  __(__  )  '
echo.Blue '/_____/\____/\__/_/ /_/_/\___/____/   '
echo.Blue 'Burhan Khanzada - Personal Dotfiles   '
echo

# Parse command line flags
AUTO_ALL=false
USE_TUI=true
DRY_RUN=false

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
        --dry-run)
            DRY_RUN=true
            ;;
        -h|--help)
            echo "Usage: ./bootstrap.sh [OPTIONS]"
            echo
            echo "Options:"
            echo "  -y, --yes, --all    Install and configure everything non-interactively"
            echo "  --no-tui            Bypass interactive TUI wizard"
            echo "  --dry-run           Preview selections without installing or prompting for sudo"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
    esac
done

# Launch interactive multi-tab TUI wizard upfront if interactive
chosen_macos_defaults=()
chosen_packages=()
chosen_brew=()
wizard_ran=false
wizard_json=""

if command -v run_tui_wizard &>/dev/null && [ "$USE_TUI" = "true" ] && [ "$AUTO_ALL" != "true" ] && [ -t 0 ]; then
    wizard_json=$(mktemp)
    trap 'rm -f "$wizard_json" 2>/dev/null' EXIT

    if run_tui_wizard full "$wizard_json"; then
        wizard_ran=true
        if [ -f "$wizard_json" ] && [ -s "$wizard_json" ]; then
            # Load selected items into bash arrays and display summary
            eval "$(python3 "$DOTFILES/core/wizard/summary.py" --env "$wizard_json")"
            python3 "$DOTFILES/core/wizard/summary.py" --print "$wizard_json"
        fi
    else
        echo
        echo.Red "==> Bootstrap cancelled by user."
        exit 0
    fi
fi

if [ "$DRY_RUN" = "true" ]; then
    echo.Yellow "==> Dry-run complete. Exiting without modifying the system."
    exit 0
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

cleanup_and_exit() {
    echo
    echo.Red "==> Bootstrap aborted by user."
    kill -TERM "$SUDO_PID" 2>/dev/null
    [ -n "$wizard_json" ] && rm -f "$wizard_json" 2>/dev/null
    exit 130
}
trap cleanup_and_exit INT TERM
trap 'kill -TERM "$SUDO_PID" 2>/dev/null; [ -n "$wizard_json" ] && rm -f "$wizard_json" 2>/dev/null' EXIT

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
if [ "$wizard_ran" = "true" ]; then
    if [ ${#chosen_brew[@]} -gt 0 ]; then
        source "$DOTFILES/brew/setup.sh" "${chosen_brew[@]}"
    else
        echo.Yellow "Skipping Homebrew packages (none selected in wizard)"
        command -v ensure_homebrew_env &>/dev/null && ensure_homebrew_env
    fi
else
    source "$DOTFILES/brew/setup.sh"
fi

# 3. Setup ZSH configuration
echo.Blue "==> [3/5] Running ZSH setup"
source "$DOTFILES/zsh/setup.sh"

# 4. Setup macOS defaults
echo.Blue "==> [4/5] Running macOS defaults"
if [ "$wizard_ran" = "true" ]; then
    if [ ${#chosen_macos_defaults[@]} -gt 0 ]; then
        for cat in "${chosen_macos_defaults[@]}"; do
            script="$DOTFILES/macos/defaults/${cat}.sh"
            if [ -f "$script" ]; then
                funcs=()
                if [ -n "$wizard_json" ] && [ -f "$wizard_json" ]; then
                    while IFS= read -r fn; do
                        [ -n "$fn" ] && funcs+=("$fn")
                    done < <(python3 "$DOTFILES/core/wizard/summary.py" --cat-funcs "$wizard_json" "$cat")
                fi

                if [ ${#funcs[@]} -gt 0 ]; then
                    echo.Blue "Applying macOS defaults: $cat (${#funcs[@]} settings)"
                    source "$script" "${funcs[@]}"
                else
                    echo.Blue "Applying macOS defaults: $cat (all settings)"
                    source "$script"
                fi
            fi
        done
    else
        echo.Yellow "Skipping macOS defaults (none selected in wizard)"
    fi
else
    source "$DOTFILES/macos/setup.sh"
fi

# 5. Setup packages
echo.Blue "==> [5/5] Running Packages setup"
if [ "$wizard_ran" = "true" ]; then
    if [ ${#chosen_packages[@]} -gt 0 ]; then
        # Run packages setup with pre-selected package list
        for pkg in "${chosen_packages[@]}"; do
            if [ -d "$DOTFILES/packages/$pkg" ]; then
                echo.Green "==> Setting up selected package: $pkg"
                installPackage "$pkg"
            fi
        done
    else
        echo.Yellow "Skipping packages setup (none selected in wizard)"
    fi
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

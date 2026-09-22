#!/usr/bin/env bash
# Package installation and lifecycle management engine.
# Executes package components (install.sh, links.sh, post_install.sh)
# without polluting or mutating ~/.zshrc.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PACKAGES_PATH="${PACKAGES_PATH:-$DOTFILES/packages}"
export DEVELOPMENT="${DEVELOPMENT:-$HOME/Development}"

# Ensure helpers are loaded portably across Bash and Zsh
command -v echo.Blue &>/dev/null || [ -f "$DOTFILES/core/colors.sh" ] && source "$DOTFILES/core/colors.sh"
command -v symlink &>/dev/null || [ -f "$DOTFILES/core/fs.sh" ] && source "$DOTFILES/core/fs.sh"
command -v continueAbortCommand &>/dev/null || [ -f "$DOTFILES/core/prompt.sh" ] && source "$DOTFILES/core/prompt.sh"

function installPackage() {
    local dir_name="$1"

    if [ -z "$dir_name" ] || [ "$dir_name" = "-h" ] || [ "$dir_name" = "--help" ]; then
        echo.Yellow "Usage: installPackage <package_name> [--update|-u]"
        if [ -d "$PACKAGES_PATH" ]; then
            echo
            echo.Blue "Available packages:"
            for d in "$PACKAGES_PATH"/*; do
                [ -d "$d" ] && echo "  - $(basename "$d")"
            done
        fi
        return 1
    fi

    local dir="$PACKAGES_PATH/$dir_name"

    if [ ! -d "$dir" ]; then
        echo.Red "Package directory does not exist: $dir"
        return 1
    fi

    # Ensure Homebrew is in PATH
    if ! command -v brew &>/dev/null; then
        if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    local prev_dir="$PWD"
    cd "$dir" || return 1

    local update_mode=false
    for arg in "$@"; do
        if [[ "$arg" == "--update" ]] || [[ "$arg" == "-u" ]]; then
            update_mode=true
            break
        fi
    done

    # 1. Install toolchain / binary (unless in update-only mode)
    if [ "$update_mode" = "false" ] && [ -f "install.sh" ]; then
        echo.Blue "  -> Installing $dir_name (install.sh)..."
        chmod +x install.sh 2>/dev/null || true
        source "install.sh"
    fi

    # 2. Configure symlinks
    if [ -f "links.sh" ]; then
        echo.Blue "  -> Linking $dir_name configs (links.sh)..."
        chmod +x links.sh 2>/dev/null || true
        source "links.sh"
    fi

    # 3. Run post-install hooks
    if [ -f "post_install.sh" ]; then
        echo.Blue "  -> Running $dir_name post-install (post_install.sh)..."
        chmod +x post_install.sh 2>/dev/null || true
        source "post_install.sh"
    fi

    # 4. Activate package environment, aliases, and functions for current shell session
    [ -f "env.zsh" ] && source "env.zsh"
    [ -f "aliases.zsh" ] && source "aliases.zsh"
    [ -f "functions.zsh" ] && source "functions.zsh"

    cd "$prev_dir" || true
    echo.Green "✔ Package $dir_name setup complete."
}

function updatePackage() {
    installPackage "$1" --update
}

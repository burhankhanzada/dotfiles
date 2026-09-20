#!/usr/bin/env bash
# Package installation and lifecycle management engine.
# Executes package components (install.sh, links.sh, post_install.sh)
# without polluting or mutating ~/.zshrc.

export PACKAGES_PATH="${PACKAGES_PATH:-$DOTFILES/packages}"

# Ensure helpers are loaded
command -v echo.Blue &>/dev/null || source "$(dirname "${BASH_SOURCE[0]}")/colors.sh" 2>/dev/null || true
command -v symlink &>/dev/null || source "$(dirname "${BASH_SOURCE[0]}")/fs.sh" 2>/dev/null || true
command -v continueAbortCommand &>/dev/null || source "$(dirname "${BASH_SOURCE[0]}")/prompt.sh" 2>/dev/null || true

function installPackage() {
    local dir_name="$1"
    local dir="$PACKAGES_PATH/$dir_name"

    if [ ! -d "$dir" ]; then
        echo.Red "Package directory does not exist: $dir"
        return 1
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

    cd "$prev_dir" || true
}

function updatePackage() {
    installPackage "$1" --update
}

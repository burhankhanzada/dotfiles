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
    local dir_name=""
    local is_dry_run=false
    local update_mode=false

    for arg in "$@"; do
        case "$arg" in
            -u|--update)
                update_mode=true
            ;;
            --dry-run)
                is_dry_run=true
            ;;
            -h|--help)
                dir_name="--help"
            ;;
            -*)
            ;;
            *)
                [ -z "$dir_name" ] && dir_name="$arg"
            ;;
        esac
    done

    if [[ "${DRY_RUN:-false}" == "true" ]]; then
        is_dry_run=true
    fi

    if [ -z "$dir_name" ] || [ "$dir_name" = "--help" ]; then
        echo.Yellow "Usage: installPackage <package_name> [--update|-u] [--dry-run]"
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

    command -v ensure_homebrew_env &>/dev/null && ensure_homebrew_env

    local prev_dir="$PWD"
    cd "$dir" || return 1

    if [ "$is_dry_run" = "true" ]; then
        echo.Yellow "  [DRY-RUN] Would configure package: $dir_name"
        [ "$update_mode" = "false" ] && [ -f "install.sh" ] && echo "    • Would execute install.sh"
        [ -f "links.sh" ] && echo "    • Would execute links.sh"
        [ -f "post_install.sh" ] && echo "    • Would execute post_install.sh"
        [ -f "env.zsh" ] && echo "    • Would load env.zsh"
        [ -f "aliases.zsh" ] && echo "    • Would load aliases.zsh"
        [ -f "functions.zsh" ] && echo "    • Would load functions.zsh"
        cd "$prev_dir" 2>/dev/null || true
        return 0
    fi

    local has_errors=0

    _run_hook() {
        local script="$1"
        local label="$2"
        [ -f "$script" ] || return 0
        echo.Blue "  -> $label $dir_name ($script)..."
        chmod +x "$script" 2>/dev/null || true
        if ! ( source "$script" ); then
            echo.Red "  ✖ Error running $script for $dir_name"
            has_errors=1
        fi
    }

    [ "$update_mode" = "false" ] && _run_hook "install.sh" "Installing"
    _run_hook "links.sh" "Linking"
    _run_hook "post_install.sh" "Running post-install for"

    # 4. Activate package environment, aliases, and functions for current shell session (Zsh only)
    if [ -n "$ZSH_VERSION" ]; then
        [ -f "env.zsh" ] && source "env.zsh"
        [ -f "aliases.zsh" ] && source "aliases.zsh"
        [ -f "functions.zsh" ] && source "functions.zsh"
    fi

    cd "$prev_dir" 2>/dev/null || true

    if [ "$has_errors" -eq 0 ]; then
        echo.Green "✔ Package $dir_name setup complete."
        return 0
    else
        echo.Yellow "⚠ Package $dir_name setup finished with warnings or errors."
        return 1
    fi
}

function updatePackage() {
    installPackage "$1" --update
}

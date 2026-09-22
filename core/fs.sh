#!/usr/bin/env bash
# Filesystem and safe symbolic linking utilities.

# Resolve colors if not loaded
command -v echo.Green &>/dev/null || [ -f "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" 2>/dev/null || true

function symlink() {
    local src="$1"
    local dst="$2"

    if [ -z "$src" ] || [ -z "$dst" ]; then
        echo.Red "Error: symlink requires source and destination arguments"
        return 1
    fi

    # Check if destination already links to source
    if [ -L "$dst" ]; then
        local current_src
        current_src=$(readlink "$dst")
        if [ "$current_src" = "$src" ]; then
            echo.Green "Link already verified: $dst -> $src"
            return 0
        else
            echo.Yellow "Updating existing link: $dst ($current_src -> $src)"
            rm -f "$dst"
            ln -s "$src" "$dst"
            return $?
        fi
    fi

    # Destination exists as a regular file/dir but is not a link
    if [ -e "$dst" ]; then
        if [ -e "$src" ]; then
            echo.Yellow "Target already exists at $dst. Backing up to ${dst}.backup"
            mv "$dst" "${dst}.backup"
        else
            # Source doesn't exist yet, move dst into src position
            local dir
            dir=$(dirname "$src")
            mkdir -p "$dir"
            echo.Yellow "Moving existing $dst -> $src"
            mv "$dst" "$src"
        fi
    fi

    # Ensure parent directory of destination exists
    local dst_dir
    dst_dir=$(dirname "$dst")
    [ ! -d "$dst_dir" ] && mkdir -p "$dst_dir"

    # Create link
    if [ -e "$src" ]; then
        ln -sfn "$src" "$dst"
        echo.Green "Created link: $dst -> $src"
    else
        echo.Yellow "Warning: Source does not exist yet ($src). Creating link anyway."
        ln -sfn "$src" "$dst"
    fi
}

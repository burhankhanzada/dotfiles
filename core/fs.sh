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

function link_shared_ide_extensions() {
    local ide_name="$1"
    local ide_ext_dir="$2"
    local base_ext="${3:-$HOME/.vscode-base-ide-extensions}"

    if [ -z "$ide_ext_dir" ]; then
        echo.Red "Error: link_shared_ide_extensions requires an extension directory path"
        return 1
    fi

    mkdir -p "$base_ext"
    mkdir -p "$(dirname "$ide_ext_dir")"

    # If extensions directory is a physical directory (not a symlink), merge into base
    if [ -d "$ide_ext_dir" ] && [ ! -L "$ide_ext_dir" ]; then
        echo.Blue "Merging existing $ide_name extensions into shared base..."
        rsync -a --ignore-existing "$ide_ext_dir/" "$base_ext/" 2>/dev/null || true
        rm -rf "$ide_ext_dir"
    fi

    # Ensure symbolic link points to shared base
    if [ ! -L "$ide_ext_dir" ] || [ "$(readlink "$ide_ext_dir")" != "$base_ext" ]; then
        rm -rf "$ide_ext_dir"
        ln -sfn "$base_ext" "$ide_ext_dir"
        echo.Green "Linked $ide_ext_dir -> $base_ext"
    else
        echo.Green "$ide_name extensions already linked: $ide_ext_dir -> $base_ext"
    fi
}

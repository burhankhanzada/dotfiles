#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

base_ext="$HOME/.vscode-base-ide-extensions"
agy_ext="$HOME/.antigravity-ide/extensions"

mkdir -p "$base_ext"
mkdir -p "$HOME/.antigravity-ide"

# If Antigravity extensions directory is a physical directory (not a symlink), merge into base
if [ -d "$agy_ext" ] && [ ! -L "$agy_ext" ]; then
    echo.Blue "Merging existing Antigravity IDE extensions into shared base..."
    rsync -a --ignore-existing "$agy_ext/" "$base_ext/" 2>/dev/null || true
    rm -rf "$agy_ext"
fi

# Ensure symbolic link points to shared base
if [ ! -L "$agy_ext" ] || [ "$(readlink "$agy_ext")" != "$base_ext" ]; then
    rm -rf "$agy_ext"
    ln -sfn "$base_ext" "$agy_ext"
    echo.Green "Linked $agy_ext -> $base_ext"
else
    echo.Green "Antigravity IDE extensions already linked: $agy_ext -> $base_ext"
fi

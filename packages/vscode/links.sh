#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

base_ext="$HOME/.vscode-base-ide-extensions"
vscode_ext="$HOME/.vscode/extensions"

mkdir -p "$base_ext"
mkdir -p "$HOME/.vscode"

# If VS Code extensions directory is a physical directory (not a symlink), merge into base
if [ -d "$vscode_ext" ] && [ ! -L "$vscode_ext" ]; then
    echo.Blue "Merging existing VS Code extensions into shared base..."
    rsync -a --ignore-existing "$vscode_ext/" "$base_ext/" 2>/dev/null || true
    rm -rf "$vscode_ext"
fi

# Ensure symbolic link points to shared base
if [ ! -L "$vscode_ext" ] || [ "$(readlink "$vscode_ext")" != "$base_ext" ]; then
    rm -rf "$vscode_ext"
    ln -sfn "$base_ext" "$vscode_ext"
    echo.Green "Linked $vscode_ext -> $base_ext"
else
    echo.Green "VS Code extensions already linked: $vscode_ext -> $base_ext"
fi

# Link Development config if available
if [ -n "$DEVELOPMENT" ] && [ -d "$DEVELOPMENT/.vscode" ]; then
    symlink "$DEVELOPMENT/.vscode" "$HOME/.vscode"
fi

#!/usr/bin/env bash
# Compatibility functions shim: loads package functions dynamically
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -d "$DOTFILES_ROOT/packages" ]; then
    for func_file in "$DOTFILES_ROOT"/packages/*/functions.zsh; do
        [ -f "$func_file" ] && source "$func_file"
    done
fi

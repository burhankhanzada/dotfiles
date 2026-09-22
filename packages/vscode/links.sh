#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

link_shared_ide_extensions "VS Code" "$HOME/.vscode/extensions"

# Link Development config if available
if [ -n "$DEVELOPMENT" ] && [ -d "$DEVELOPMENT/.vscode" ]; then
    symlink "$DEVELOPMENT/.vscode" "$HOME/.vscode"
fi

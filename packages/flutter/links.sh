#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

flutter="${DEVELOPMENT:-$HOME/Development}/Google/Flutter"
mkdir -p "$flutter"

symlink "$flutter/fvm" "$HOME/fvm"
symlink "$flutter/.dart" "$HOME/.dart"
symlink "$flutter/.dart-tool" "$HOME/.dart-tool"
symlink "$flutter/.pub-cache" "$HOME/.pub-cache"
symlink "$flutter/.dartserver" "$HOME/.dartserver"

#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

# Gradle serves every JVM build (Android, MDE4CPP, ...), so its home sits beside them rather than inside one
gradle="${DEVELOPMENT:-$HOME/Development}/Gradle"

mkdir -p "$gradle/.gradle"

symlink "$gradle/.gradle" "$HOME/.gradle"

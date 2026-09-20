#!/usr/bin/env bash

# Source files from functions directory so they are accessible from every shell instance
for file in "$DOTFILES/functions/"*.sh "$DOTFILES/functions/"*.zsh; do
    [ -f "$file" ] && source "$file"
done

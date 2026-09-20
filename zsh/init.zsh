#!/usr/bin/env zsh
# Dynamic Zsh Dotfiles Loader
# Automatically discovers and sources modular configurations from packages.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# 1. Load core library
[ -f "$DOTFILES/core/colors.sh" ] && source "$DOTFILES/core/colors.sh"

# 2. Load global shell environment variables
[ -f "$DOTFILES/zsh/env.zsh" ] && source "$DOTFILES/zsh/env.zsh"

# 3. Load global shell aliases
[ -f "$DOTFILES/zsh/aliases.zsh" ] && source "$DOTFILES/zsh/aliases.zsh"

# 4. Dynamically load modular package environment variables & PATHs
if [ -d "$DOTFILES/packages" ]; then
    for env_file in "$DOTFILES"/packages/*/env.zsh; do
        [ -f "$env_file" ] && source "$env_file"
    done

    # 5. Dynamically load modular package aliases
    for alias_file in "$DOTFILES"/packages/*/aliases.zsh; do
        [ -f "$alias_file" ] && source "$alias_file"
    done

    # 6. Dynamically load modular package functions
    for func_file in "$DOTFILES"/packages/*/functions.zsh; do
        [ -f "$func_file" ] && source "$func_file"
    done
fi

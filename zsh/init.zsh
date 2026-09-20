#!/usr/bin/env zsh
# Dynamic Zsh Dotfiles Loader
# Automatically discovers and sources modular configurations from packages
# without requiring hardcoded modifications to ~/.zshrc.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# 1. Load core library
if [ -f "$DOTFILES/core/colors.sh" ]; then
    source "$DOTFILES/core/colors.sh"
elif [ -f "$DOTFILES/functions/color.zsh" ]; then
    source "$DOTFILES/functions/color.zsh"
fi

# 2. Load global shell environment variables
if [ -f "$DOTFILES/zsh/env.zsh" ]; then
    source "$DOTFILES/zsh/env.zsh"
elif [ -f "$DOTFILES/zsh/.zshenv" ]; then
    source "$DOTFILES/zsh/.zshenv"
fi

# 3. Load global shell aliases
if [ -f "$DOTFILES/zsh/aliases.zsh" ]; then
    source "$DOTFILES/zsh/aliases.zsh"
elif [ -f "$DOTFILES/zsh/aliases.sh" ]; then
    source "$DOTFILES/zsh/aliases.sh"
fi

# 4. Dynamically load modular package environment variables & PATHs
if [ -d "$DOTFILES/packages" ]; then
    for env_file in "$DOTFILES"/packages/*/env.zsh "$DOTFILES"/packages/*/environment_variables.sh; do
        [ -f "$env_file" ] && source "$env_file"
    done

    # 5. Dynamically load modular package aliases
    for alias_file in "$DOTFILES"/packages/*/aliases.zsh "$DOTFILES"/packages/*/aliases.sh; do
        [ -f "$alias_file" ] && source "$alias_file"
    done

    # 6. Dynamically load modular package functions
    for func_file in "$DOTFILES"/packages/*/functions.zsh "$DOTFILES"/packages/*/functions.sh; do
        [ -f "$func_file" ] && source "$func_file"
    done
fi

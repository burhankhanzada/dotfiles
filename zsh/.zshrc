#!/usr/bin/env zsh
# Core interactive shell entry point.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# Initialize modular dotfiles
[ -f "$DOTFILES/zsh/init.zsh" ] && source "$DOTFILES/zsh/init.zsh"

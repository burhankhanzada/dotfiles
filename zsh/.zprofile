#!/usr/bin/env bash

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/aliases.sh"

functions_path="$DOTFILES/functions"

source "$functions_path/color.zsh"

source "$functions_path/link.sh"

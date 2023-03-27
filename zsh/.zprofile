#!/usr/bin/env bash

export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/aliases.sh"

export FUNCTIONS_PATH="$DOTFILES/functions"

source "$FUNCTIONS_PATH/color.zsh"

source "$FUNCTIONS_PATH/link.sh"

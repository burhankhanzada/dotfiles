#!/usr/bin/env bash

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

export YABAI_PATH="$DOTFILES/after_brew/yabai"

brew services start yabai

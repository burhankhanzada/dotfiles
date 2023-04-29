#!/usr/bin/env bash

brew install koekeishiya/formulae/skhd
brew install koekeishiya/formulae/yabai

brew services start skhd
brew services start yabai

export YABAI_PATH="$DOTFILES/after_brew/yabai"

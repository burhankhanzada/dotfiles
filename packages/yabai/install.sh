#!/usr/bin/env bash

brew install koekeishiya/formulae/skhd
brew install koekeishiya/formulae/yabai

sudo brew services start skhd
sudo brew services start yabai

export YABAI_PATH=$PACKAGES_PATH/yabai

#!/usr/bin/env bash

echo "Running ZSH setup"

cd "$DOTFILES/zsh"

cp -f .zshrc ~/.zshrc
cp -f .zshenv ~/.zshenv
cp -f .zprofile ~/.zprofile

source ~/.zprofile

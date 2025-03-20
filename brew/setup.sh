#!/usr/bin/env bash

echo.Blue "Running Homebrew setup"

cd $DOTFILES/brew

if [ -f "install.sh" ]; then
    echo.Yellow "Installing from $0"
    chmod +x install.sh
    source install.sh
fi

if [ -f "links.sh" ]; then
    echo
    echo.Blue "Running from $0"
    chmod +x links.sh
    source "links.sh"
fi
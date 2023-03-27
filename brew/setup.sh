#!/usr/bin/env bash

echo "Running Homebrew setup"

cd "$DOTFILES/brew"

if [ -f "install.sh" ]; then
    echo.Blue "Installing from $0"
    chmod +x install.sh
    ./install.sh
fi

if [ -f "links.prop" ]; then
    echo.Blue "Linking from $0"
    link_files links.prop
fi

source ~/.zprofile

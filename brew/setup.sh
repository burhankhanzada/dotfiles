#!/usr/bin/env bash

echo.Blue "Running Homebrew setup"

cd $DOTFILES/brew

if [ -f "install.sh" ]; then
    echo.Yellow "Installing from $0"
    chmod +x install.sh
    ./install.sh
fi

if [ -f "links.prop" ]; then
    echo.Yellow "Linking from $0"
    link_files links.prop
fi

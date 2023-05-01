#!/usr/bin/env bash

echo.Blue "Running Homebrew setup"

cd $DOTFILES/brew

if [ -f "install.sh" ]; then
    echo.Yellow "Installing from $0"
    chmod +x install.sh
    source install.sh
fi

if [ -f "links.prop" ]; then
    echo.Yellow "Linking from $0"
    link_files links.prop
fi

# if [ -f "after_links.sh" ]; then
#     echo.Yellow "Runnig from $0"
#     chmod +x after_links.sh
#     source after_links.sh
# fi

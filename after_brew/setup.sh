#!/usr/bin/env bash

after_brew="$DOTFILES/after_brew"

directories=(
    "yabai"
    "alt_tab"
    "keycastr"
    "whichspace"
    "chrome"
    "warp"
    "git"
    "exa"
    "vscode"
    "android"
    "flutter"
    "java"
    "gradle"
    "firebase"
    "fonts"
    "python"
    "ruby"
    "cocoapods"
    "node"
    "whatsapp"
    "parallels"
    "motrix"
    # "wine"
    # "rectangle"
)

for dir_name in "${directories[@]}"; do

    dir="$after_brew/$dir_name/"
    cd "$dir"

    if [ -f "install.sh" ]; then
        echo.Blue "Installing from $dir"
        chmod +x install.sh
        # shellcheck source=/dev/null
        source "install.sh"
    fi

    if [ -f "enviornment_varaibles.sh" ]; then
        echo.Blue "Adding enviornment varaibles from $dir"
        echo "source $dir/enviornment_varaibles.sh" >>~/.zshrc
    fi

    if [ -f "aliases.sh" ]; then
        echo.Blue "Adding aliases from $dir"
        echo "source $dir/aliases.sh" >>~/.zshrc
    fi

    if [ -f "functions.sh" ]; then
        echo.Blue "Adding functions from $dir"
        echo "source $dir/functions.sh" >>~/.zshrc
    fi

    if [ -f "links.prop" ]; then
        echo.Blue "Linking from $dir"
        link_files links.prop
    fi

    if [ -f "after_links.sh" ]; then
        echo.Blue "Runnig from $dir"
        chmod +x after_links.sh
        # shellcheck source=/dev/null
        source "after_links.sh"
    fi

    source ~/.zshenv
    source ~/.zshrc

    cd "$after_brew"
done

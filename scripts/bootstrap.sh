#!/usr/bin/env bash

# cd "$(dirname "$0")/.."
# DOTFILES=$(pwd -P)

export DOTFILES="$HOME/.dotfiles"

# To stop executuion and get error with line if any error occur
set +e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# shellcheck source=/dev/null
source "$DOTFILES/scripts/mac_os_defaults/set.sh"

# shellcheck source=/dev/null
source "$DOTFILES/zsh/setup.sh"

# shellcheck source=/dev/null
source "$DOTFILES/brew/setup.sh"

after_brew="$DOTFILES/after_brew"

directories=(
    # "chrome"
    # "warp"
    # "alt_tab"
    "git"
    # "exa"
    # "vscode"
    # "android"
    # "flutter"
    # "java"
    # "gradle"
    # "firebase"
    # "fonts"
    # "python"
    # "ruby"
    # "cocoapods"
    # "node"
    # "whatsapp"
    # "parallels"
    # "motrix"
    # "wine"
    # "cache"
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

    dir="$after_brew/$dir_name"

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

    source ~/.zshenv
    source ~/.zshrc

    cd "$after_brew"
done
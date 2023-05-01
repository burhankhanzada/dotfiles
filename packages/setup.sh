#!/usr/bin/env bash

function installPackage() {

    local dir_name=$1

    dir="$PACKAGES_PATH/$dir_name/"
    cd "$dir"

    if [ -f "install.sh" ]; then
        echo
        echo.Blue "Installing from $dir"
        chmod +x install.sh
        source "install.sh"
    fi

    if [ -f "enviornment_varaibles.sh" ]; then
        echo
        echo.Blue "Adding enviornment varaibles from $dir"
        echo "source $dir/enviornment_varaibles.sh" >>~/.zshrc
    fi

    if [ -f "aliases.sh" ]; then
        echo
        echo.Blue "Adding aliases from $dir"
        echo "source $dir/aliases.sh" >>~/.zshrc
    fi

    if [ -f "functions.sh" ]; then
        echo
        echo.Blue "Adding functions from $dir"
        echo "source $dir/functions.sh" >>~/.zshrc
    fi

    if [ -f "links.prop" ]; then
        echo
        echo.Blue "Linking from $dir"
        link_files links.prop
    fi

    if [ -f "after_links.sh" ]; then
        echo
        echo.Blue "Runnig from $dir"
        chmod +x after_links.sh
        source "after_links.sh"
    fi

    source ~/.zshenv
    source ~/.zshrc

    cd "$PACKAGES_PATH"
}

export PACKAGES_PATH="$DOTFILES/packages"

# ordered according to priority
directories=(
    "yabai"
    "spaceid"
    "alt_tab"
    "keycastr"
    "chrome"
    "warp"
    "motrix"
    "whatsapp"
    "parallels"
    "fonts"
    "git"
    "exa"
    "vscode"
    "android"
    "java"
    "gradle"
    "flutter"
    "firebase"
    "python"
    "node"
    "bun"
    "suraaldb"
    "ruby"
    "cocoapods"
    # "wine"
    # "rectangle"
)

ask_to_run=(
    "yabai"
    "paralles"
    "android"
    "flutter"
    "firebase"
    "ruby"
    "cocoapods"

)

for dir_name in "${directories[@]}"; do

    skip_parent_loop=false

    # to check if current dir name is ask_to_run list then allow user interaction
    for dir_name2 in "${ask_to_run[@]}"; do

        if [[ "$dir_name" == "$dir_name2" ]]; then

            echo
            echo.Magenta "Install $dir_name"
            echo.Magenta "Press RETURN/ENTER to continue or any other key to abort"
            read -n 1 key

            if [[ $key = "" ]]; then

                installPackage $dir_name
            else
                echo
                echo.Red "Aborted."
                skip_parent_loop=true
                break
            fi
        fi

    done

    if $skip_parent_loop; then
        continue
    fi

    installPackage $dir_name

done

#!/usr/bin/env bash

# ordered according to priority
direct_install=(
    "chrome"
    "warp"
    "vscode"
    "motrix"
    "whatsapp"
    "wpsoffice"
    "teamviewer"
    "jq"
    "exa"
    "git"
    "fonts"
    "alttab"
    "genric"
    "spaceid"
    "keycastr"
    "bluesnooze"
)

for dir_name in "${direct_install[@]}"; do
    installPackage $dir_name
done

ask_to_install=(
    "yabai"
    "fleet"
    "parallels"
    "java"
    "android"
    "flutter"
    "firebase"
    "python"
    "node"
    "bun"
    "surrealdb"
    "ruby"
    "cocoapods"
    # "wine"
    # "rectangle"
)

for dir_name in "${ask_to_install[@]}"; do

    echo
    echo.Magenta "Install $dir_name?"
    echo.Magenta "Press RETURN/ENTER to continue or any other key to abort"
    read -n 1 key

    if [[ $key = "" ]]; then
        installPackage $dir_name
    else
        echo
        echo.Red "Aborted."
        continue
    fi

done

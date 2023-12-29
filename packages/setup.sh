#!/usr/bin/env bash

ask_to_install=(
    # cli
    "git"
    "exa"
    "jq"

    # system
    "fonts"
    "genric"
    "stats"
    "alttab"
    "spaceid"
    "rectangle"
    "lensocr"
    "shottr"
    "keycastr"
    "bluesnooze"
    "cxpatcher"
    # "wine" commented in favor of parallels
    # "yabai" commented in favor of rectangle

    # apps
    "chrome"
    "spotify"
    "whatsapp"
    "telegram"
    "figma"
    "motrix"
    "obs"
    "audacity"
    "grammarly"
    "parallels"
    "skype"
    "anydesk"
    "teamviewer"
    "discord"
    # "wpsoffice" commented because not updated
    "zoom"
    "zotero"
    
    # development
    "warp"
    "vscode"
    "flutter"
    "android"
    "node"
    "firebase"
    "java"
    "python"
    "ruby"
    "cocoapods"
    "bun"
    "fleet"
    "scrcpy"
    "postman"
    "gitkraken"
    "surrealdb"
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

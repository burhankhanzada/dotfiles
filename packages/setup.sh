#!/usr/bin/env bash

ask_to_install=(
    # cli
    "jq"
    "exa"
    "git"

    # system
    "fonts"
    "state"
    "yabai"
    "alttab"
    "genric"
    "shottr"
    "spaceid"
    "keycastr"
    "rectangle"
    "bluesnooze"

    # normal
    "skype"
    "figma"
    "chrome"
    "motrix"
    "zotero"
    "spotify"
    "anydesk"
    "whatsapp"
    "grammarly"
    "parallels"
    "teamviewer"
    # "wine" commented in favor of parallels
    # "wpsoffice" commented coz a year old version

    # development
    "bun"
    "warp"
    "ruby"
    "java"
    "node"
    "fleet"
    "vscode"
    "python"
    "scrcpy"
    "postman"
    "android"
    "flutter"
    "firebase"
    "gitkraken"
    "cocoapods"
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

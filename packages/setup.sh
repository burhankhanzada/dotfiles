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
    "swiftquit"
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
    "szcontext"
    "whatsapp"
    "telegram"
    "spotify"
    "spotube"
    "motrix"
    "vlc"
    "audacity"
    "obs"
    "grammarly"
    "urbanvpn"
    "parallels"
    "anydesk"
    "teamviewer"
    "discord"
    "zoom"
    "zotero"
    # "skype" commneted as discontinued
    # "wpsoffice" commented because not updated

    # development
    "warp"
    "figma"
    "vscode"
    "postman"
    "flutter"
    "ruby"
    "cocoapods"
    "xcode"
    "android"
    "firebase"
    "python"
    "java"
    "cmake"
    "ninja"
    "llvm"
    "bun"
    "node"
    "fleet"
    "scrcpy"
    "surrealdb"
    "gitkraken"
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

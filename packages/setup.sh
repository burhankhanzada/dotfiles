#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Magenta &>/dev/null || echo.Magenta() { echo -e "\033[0;35m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }

ask_to_install=(
    # cli
    "git"
    "exa"
    "jq"
    "mole"

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

#!/usr/bin/env bash

# ordered according to priority
direct_install=(

    "rectangle"
    "chrome"
    "warp"
    "vscode"
    "whatsapp"
    "spotify"
    "motrix"
    "jq"
    "exa"
    "git"
    "state"
    "alttab"
    "spaceid"
    "keycastr"
    "bluesnooze"
    "genric"
    "fonts"
)

for dir_name in "${direct_install[@]}"; do
    installPackage $dir_name
done

ask_to_install=(
    "android"
    "flutter"
    "firebase"
    "python"
    "teamviewer"
    "parallels"
    "zotero"
    "scrcpy"
    "node"
    "bun"
    "surrealdb"
    "java"
    "ruby"
    "cocoapods"
    "fleet"
    "yabai"
    # "wine" commented in favor of parallels
    # "wpsoffice" commented coz a year old version
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

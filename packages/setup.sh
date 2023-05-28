#!/usr/bin/env bash

# ordered according to priority
direct_install=(
    "chrome"
    "yabai"
    "jq"
    "exa"
    "git"
    "fonts"
    "state"
    "alttab"
    "genric"
    "spaceid"
    "keycastr"
    "bluesnooze"
    "warp"
    "vscode"
)

for dir_name in "${direct_install[@]}"; do
    installPackage $dir_name
done

ask_to_install=(
    "parallels"
    "whatsapp"
    "teamviewer"
    "motrix"
    "fleet"
    "android"
    "zotero"
    "flutter"
    "firebase"
    "python"
    "node"
    "bun"
    "surrealdb"
    "java"
    "ruby"
    "cocoapods"
    # "wine" commented in favor of parallels
    # "rectangle" commented in favor of yabai
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

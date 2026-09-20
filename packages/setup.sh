#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Magenta &>/dev/null || echo.Magenta() { echo -e "\033[0;35m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

# Only packages with custom setup, configurations, or symlinks
packages_with_configs=(
    "git"
    "vscode"
    "warp"
    "generic"
    "flutter"
    "android"
    "xcode"
    "python"
    "ruby"
    "rust"
    "node"
    "java"
    "cmake"
    "cocoapods"
    "llvm"
    "parallels"
    "firebase"
    "yabai"
    "wine"
)

echo.Blue "==> Configuring packages with custom settings & links"

for dir_name in "${packages_with_configs[@]}"; do
    [ -d "$DOTFILES/packages/$dir_name" ] || continue

    echo
    echo.Magenta "Configure/Setup $dir_name?"
    echo.Magenta "Press RETURN/ENTER to continue or any other key to skip"
    read -n 1 key

    if [[ $key = "" ]]; then
        installPackage "$dir_name"
    else
        echo
        echo.Red "Skipped $dir_name."
        continue
    fi
done

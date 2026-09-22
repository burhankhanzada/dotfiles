#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

function system_screenshot_dir() {
    echo.Green "  Set screenshot destination to Pictures/Screenshots"
    mkdir -p "$HOME/Pictures/Screenshots"
    defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
}

function system_screenshot_no_shadow() {
    echo.Green "  Disable window shadow in screenshots"
    defaults write com.apple.screencapture disable-shadow -bool true
}

function system_screenshot_jpg() {
    echo.Green "  Set screenshot format to JPG"
    defaults write com.apple.screencapture type -string jpg
}

function system_screenshot_no_thumbnail() {
    echo.Green "  Disable floating thumbnail after screenshot"
    defaults write com.apple.screencapture show-thumbnail -bool false
}

function system_screenshot_no_date() {
    echo.Green "  Disable date and time in screenshot filenames"
    defaults write com.apple.screencapture include-date -bool false
}

function system_disk_utility_all_devices() {
    echo.Green "  Show all devices in Disk Utility sidebar"
    defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true
}

function system_metal_hud() {
    echo.Green "  Enable Metal HUD overlay for graphics performance"
    defaults write -g MetalForceHudEnabled -bool true
}

echo.Green "==> Configuring System, Screenshots & Diagnostics Defaults"

if [ $# -gt 0 ]; then
    for fn in "$@"; do
        [[ "$fn" != system_* ]] && fn="system_$fn"
        if declare -f "$fn" >/dev/null; then
            "$fn"
        fi
    done
else
    if [ -n "$ZSH_VERSION" ]; then
        funcs=(${(f)"$(print -l ${(ok)functions[(I)system_*]} | sort)"})
    else
        funcs=($(compgen -A function system_ | sort))
    fi
    for fn in "${funcs[@]}"; do
        "$fn"
    done
fi

killall SystemUIServer 2>/dev/null || true

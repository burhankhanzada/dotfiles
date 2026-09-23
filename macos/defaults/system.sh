#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

function _is_disable() {
    [[ "$1" == "false" || "$1" == "off" || "$1" == "disable" || "$1" == "0" ]]
}

function system_screenshot_dir() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset screenshot destination to default Desktop"
        defaults delete com.apple.screencapture location 2>/dev/null || true
    else
        echo.Green "  Set screenshot destination to Pictures/Screenshots"
        mkdir -p "$HOME/Pictures/Screenshots"
        defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
    fi
}

function system_screenshot_no_shadow() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable window shadow in screenshots"
        defaults write com.apple.screencapture disable-shadow -bool false
    else
        echo.Green "  Disable window shadow in screenshots"
        defaults write com.apple.screencapture disable-shadow -bool true
    fi
}

function system_screenshot_jpg() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset screenshot format to default PNG"
        defaults write com.apple.screencapture type -string png
    else
        echo.Green "  Set screenshot format to JPG"
        defaults write com.apple.screencapture type -string jpg
    fi
}

function system_screenshot_no_thumbnail() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable floating thumbnail after screenshot"
        defaults write com.apple.screencapture show-thumbnail -bool true
    else
        echo.Green "  Disable floating thumbnail after screenshot"
        defaults write com.apple.screencapture show-thumbnail -bool false
    fi
}

function system_screenshot_no_date() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable date and time in screenshot filenames"
        defaults write com.apple.screencapture include-date -bool true
    else
        echo.Green "  Disable date and time in screenshot filenames"
        defaults write com.apple.screencapture include-date -bool false
    fi
}

function system_disk_utility_all_devices() {
    if _is_disable "$1"; then
        echo.Yellow "  Hide all devices in Disk Utility sidebar"
        defaults write com.apple.DiskUtility SidebarShowAllDevices -bool false
    else
        echo.Green "  Show all devices in Disk Utility sidebar"
        defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true
    fi
}

function system_metal_hud() {
    if _is_disable "$1"; then
        echo.Yellow "  Disable Metal HUD overlay for graphics performance"
        defaults write -g MetalForceHudEnabled -bool false
        defaults delete -g MetalForceHudEnabled 2>/dev/null || true
    else
        echo.Green "  Enable Metal HUD overlay for graphics performance"
        defaults write -g MetalForceHudEnabled -bool true
    fi
}

echo.Green "==> Configuring System, Screenshots & Diagnostics Defaults"
run_defaults_functions "system" "$@"

killall SystemUIServer 2>/dev/null || true

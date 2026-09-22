#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
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
run_defaults_functions "system" "$@"

killall SystemUIServer 2>/dev/null || true

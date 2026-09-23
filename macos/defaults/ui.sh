#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

function _is_disable() {
    [[ "$1" == "false" || "$1" == "off" || "$1" == "disable" || "$1" == "0" ]]
}

function ui_dark_mode() {
    if _is_disable "$1"; then
        echo.Yellow "  Set light theme"
        defaults delete -g AppleInterfaceStyle 2>/dev/null || true
    else
        echo.Green "  Set dark theme"
        defaults write -g AppleInterfaceStyle -string Dark
    fi
}

function ui_reduce_motion() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable default animations"
        defaults write com.apple.Accessibility ReduceMotionEnabled -bool false
    else
        echo.Green "  Reduce animations"
        defaults write com.apple.Accessibility ReduceMotionEnabled -bool true
    fi
}

function ui_dock_left() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset Dock position to bottom"
        defaults write com.apple.dock orientation -string bottom
    else
        echo.Green "  Set Dock position to left"
        defaults write com.apple.dock orientation -string left
    fi
}

function ui_dock_compact() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset Dock tile size and magnification"
        defaults write com.apple.dock tilesize -int 48
        defaults write com.apple.dock magnification -bool false
    else
        echo.Green "  Set compact Dock (35px) with magnification (50px)"
        defaults write com.apple.dock tilesize -int 35
        defaults write com.apple.dock largesize -int 50
        defaults write com.apple.dock magnification -bool true
    fi
}

function ui_dock_active_only() {
    if _is_disable "$1"; then
        echo.Yellow "  Show all pinned apps in Dock"
        defaults write com.apple.dock static-only -bool false
        defaults write com.apple.dock show-recents -bool true
    else
        echo.Green "  Show only active apps in Dock"
        defaults write com.apple.dock static-only -bool true
        defaults write com.apple.dock show-recents -bool false
    fi
}

function ui_dock_minimize_app() {
    if _is_disable "$1"; then
        echo.Yellow "  Disable minimize windows into app icon (genie effect)"
        defaults write com.apple.dock minimize-to-application -bool false
        defaults write com.apple.dock mineffect -string genie
    else
        echo.Green "  Minimize windows into app icon (scale effect)"
        defaults write com.apple.dock minimize-to-application -bool true
        defaults write com.apple.dock mineffect -string scale
    fi
}

function ui_dock_dim_hidden() {
    if _is_disable "$1"; then
        echo.Yellow "  Do not dim hidden application icons"
        defaults write com.apple.dock showhidden -bool false
    else
        echo.Green "  Dim hidden application icons (Cmd + H)"
        defaults write com.apple.dock showhidden -bool true
    fi
}

function ui_spaces_fixed() {
    if _is_disable "$1"; then
        echo.Yellow "  Allow automatically rearranging Spaces based on most recent use"
        defaults write com.apple.dock mru-spaces -bool true
    else
        echo.Green "  Disable automatically rearrange Spaces"
        defaults write com.apple.dock mru-spaces -bool false
        defaults write com.apple.dock showAppExposeGestureEnabled -bool true
        defaults write com.apple.dock showMissionControlGestureEnabled -bool true
    fi
}

function ui_launchpad_grid() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset Launchpad grid layout to system defaults"
        defaults delete com.apple.dock springboard-rows 2>/dev/null || true
        defaults delete com.apple.dock springboard-columns 2>/dev/null || true
    else
        echo.Green "  Set Launchpad grid (6 rows x 8 cols)"
        defaults write com.apple.dock springboard-rows -int 6
        defaults write com.apple.dock springboard-columns -int 8
    fi
}

function ui_battery_percent() {
    if _is_disable "$1"; then
        echo.Yellow "  Hide battery percentage in menu bar"
        defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool false
        defaults write com.apple.controlcenter BatteryShowPercentage -bool false
    else
        echo.Green "  Show battery percentage in menu bar"
        defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
        defaults write com.apple.controlcenter BatteryShowPercentage -bool true
    fi
}

function ui_hide_spotlight() {
    if _is_disable "$1"; then
        echo.Yellow "  Show Spotlight icon in menu bar"
        defaults write com.apple.Spotlight MenuItemHidden -bool false
    else
        echo.Green "  Hide Spotlight icon from menu bar"
        defaults write com.apple.Spotlight MenuItemHidden -bool true
    fi
}

echo.Green "==> Configuring UI & Appearance Defaults"
run_defaults_functions "ui" "$@"

killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true

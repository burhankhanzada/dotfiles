#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

function ui_dark_mode() {
    echo.Green "  Set dark theme"
    defaults write -g AppleInterfaceStyle -string Dark
}

function ui_reduce_motion() {
    echo.Green "  Reduce animations"
    defaults write com.apple.Accessibility ReduceMotionEnabled -bool true
}

function ui_dock_left() {
    echo.Green "  Set Dock position to left"
    defaults write com.apple.dock orientation -string left
}

function ui_dock_compact() {
    echo.Green "  Set compact Dock (35px) with magnification (50px)"
    defaults write com.apple.dock tilesize -int 35
    defaults write com.apple.dock largesize -int 50
    defaults write com.apple.dock magnification -bool true
}

function ui_dock_active_only() {
    echo.Green "  Show only active apps in Dock"
    defaults write com.apple.dock static-only -bool true
    defaults write com.apple.dock show-recents -bool false
}

function ui_dock_minimize_app() {
    echo.Green "  Minimize windows into app icon (scale effect)"
    defaults write com.apple.dock minimize-to-application -bool true
    defaults write com.apple.dock mineffect -string scale
}

function ui_dock_dim_hidden() {
    echo.Green "  Dim hidden application icons (Cmd + H)"
    defaults write com.apple.dock showhidden -bool true
}

function ui_spaces_fixed() {
    echo.Green "  Disable automatically rearrange Spaces"
    defaults write com.apple.dock mru-spaces -bool false
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true
    defaults write com.apple.dock showMissionControlGestureEnabled -bool true
}

function ui_launchpad_grid() {
    echo.Green "  Set Launchpad grid (6 rows x 8 cols)"
    defaults write com.apple.dock springboard-rows -int 6
    defaults write com.apple.dock springboard-columns -int 8
}

function ui_battery_percent() {
    echo.Green "  Show battery percentage in menu bar"
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
    defaults write com.apple.controlcenter BatteryShowPercentage -bool true
}

function ui_hide_spotlight() {
    echo.Green "  Hide Spotlight icon from menu bar"
    defaults write com.apple.Spotlight MenuItemHidden -bool true
}

all_ui_functions=(
    ui_dark_mode
    ui_reduce_motion
    ui_dock_left
    ui_dock_compact
    ui_dock_active_only
    ui_dock_minimize_app
    ui_dock_dim_hidden
    ui_spaces_fixed
    ui_launchpad_grid
    ui_battery_percent
    ui_hide_spotlight
)

echo.Green "==> Configuring UI & Appearance Defaults"

if [ $# -gt 0 ]; then
    for fn in "$@"; do
        [[ "$fn" != ui_* ]] && fn="ui_$fn"
        if declare -f "$fn" >/dev/null; then
            "$fn"
        fi
    done
else
    for fn in "${all_ui_functions[@]}"; do
        "$fn"
    done
fi

killall Dock 2>/dev/null || true
killall ControlCenter 2>/dev/null || true

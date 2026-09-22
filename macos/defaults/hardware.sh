#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

function hardware_fast_key_repeat() {
    echo.Green "  Set fast keyboard repeat rate"
    defaults write -g KeyRepeat -int 3
    defaults write -g InitialKeyRepeat -int 12
}

function hardware_disable_press_hold() {
    echo.Green "  Disable press-and-hold for keys in favor of key repeat"
    defaults write -g ApplePressAndHoldEnabled -bool false
}

function hardware_disable_autocap() {
    echo.Green "  Disable automatic capitalization"
    defaults write -g NSAutomaticCapitalizationEnabled -bool false
}

function hardware_tap_to_click() {
    echo.Green "  Enable tap to click on trackpad"
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
}

function hardware_three_finger_drag() {
    echo.Green "  Enable 3-finger dragging"
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
}

function hardware_disable_chrome_swipe() {
    echo.Green "  Disable sensitive backswipe on Chrome trackpads"
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
}

function hardware_mute_startup_chime() {
    echo.Green "  Mute startup sound / chime"
    sudo nvram StartupMute=%01 2>/dev/null || true
}

function hardware_display_sleep() {
    echo.Green "  Configure system sleep and display timeout"
    sudo pmset -a disablesleep 0 2>/dev/null || true
    sudo pmset -b displaysleep 15 2>/dev/null || true
    sudo pmset -c displaysleep 30 2>/dev/null || true
}

echo.Green "==> Configuring Hardware, Input & Power Defaults"

if [ $# -gt 0 ]; then
    for fn in "$@"; do
        [[ "$fn" != hardware_* ]] && fn="hardware_$fn"
        if declare -f "$fn" >/dev/null; then
            "$fn"
        fi
    done
else
    if [ -n "$ZSH_VERSION" ]; then
        funcs=(${(f)"$(print -l ${(ok)functions[(I)hardware_*]} | sort)"})
    else
        funcs=($(compgen -A function hardware_ | sort))
    fi
    for fn in "${funcs[@]}"; do
        "$fn"
    done
fi

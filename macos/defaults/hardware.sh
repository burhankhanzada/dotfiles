#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

function _is_disable() {
    [[ "$1" == "false" || "$1" == "off" || "$1" == "disable" || "$1" == "0" ]]
}

function hardware_fast_key_repeat() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset keyboard repeat rate to system defaults"
        defaults delete -g KeyRepeat 2>/dev/null || true
        defaults delete -g InitialKeyRepeat 2>/dev/null || true
    else
        echo.Green "  Set fast keyboard repeat rate"
        defaults write -g KeyRepeat -int 3
        defaults write -g InitialKeyRepeat -int 12
    fi
}

function hardware_disable_press_hold() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable press-and-hold for accented keys"
        defaults write -g ApplePressAndHoldEnabled -bool true
    else
        echo.Green "  Disable press-and-hold for keys in favor of key repeat"
        defaults write -g ApplePressAndHoldEnabled -bool false
    fi
}

function hardware_disable_autocap() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable automatic capitalization"
        defaults write -g NSAutomaticCapitalizationEnabled -bool true
    else
        echo.Green "  Disable automatic capitalization"
        defaults write -g NSAutomaticCapitalizationEnabled -bool false
    fi
}

function hardware_tap_to_click() {
    if _is_disable "$1"; then
        echo.Yellow "  Disable tap to click on trackpad"
        defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
        defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool false
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
    else
        echo.Green "  Enable tap to click on trackpad"
        defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
        defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -bool true
        defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    fi
}

function hardware_three_finger_drag() {
    if _is_disable "$1"; then
        echo.Yellow "  Disable 3-finger dragging"
        defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
    else
        echo.Green "  Enable 3-finger dragging"
        defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
        defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
        defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
    fi
}

function hardware_disable_chrome_swipe() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable backswipe on Chrome trackpads"
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool true
        defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool true
    else
        echo.Green "  Disable sensitive backswipe on Chrome trackpads"
        defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
        defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
    fi
}

function hardware_mute_startup_chime() {
    if _is_disable "$1"; then
        echo.Yellow "  Unmute startup sound / chime"
        sudo nvram -d StartupMute 2>/dev/null || sudo nvram StartupMute=%00 2>/dev/null || true
    else
        echo.Green "  Mute startup sound / chime"
        sudo nvram StartupMute=%01 2>/dev/null || true
    fi
}

function hardware_display_sleep() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset display timeout to default (10m)"
        sudo pmset -b displaysleep 10 2>/dev/null || true
        sudo pmset -c displaysleep 10 2>/dev/null || true
    else
        echo.Green "  Configure system sleep and display timeout"
        sudo pmset -a disablesleep 0 2>/dev/null || true
        sudo pmset -b displaysleep 15 2>/dev/null || true
        sudo pmset -c displaysleep 30 2>/dev/null || true
    fi
}

echo.Green "==> Configuring Hardware, Input & Power Defaults"
run_defaults_functions "hardware" "$@"

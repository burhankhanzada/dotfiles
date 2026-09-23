#!/usr/bin/env zsh
# Android CLI, AVD & ADB shortcuts and productivity helpers.

# AVD management
alias avd-list="avdmanager list avd"

function avd-run() {
    if [ -z "$1" ]; then
        echo "Usage: avd-run <avd_name>"
        echo "Available AVDs:"
        avdmanager list avd | grep -E "Name:" | sed 's/.*Name: /  - /'
        return 1
    fi
    emulator -avd "$1" "${@:2}" &>/dev/null &!
    echo "Launched Android emulator '$1' in background."
}

# ADB device & connection shortcuts
alias adb-devices="adb devices -l"
alias adb-restart="adb kill-server && adb start-server"
alias adb-logcat-clear="adb logcat -c"

# Pull device IP address over WiFi ADB
function adb-ip() {
    local ip
    ip=$(adb shell ip -f inet addr show wlan0 2>/dev/null | grep -E "inet " | awk '{print $2}' | cut -d/ -f1)
    if [ -n "$ip" ]; then
        echo "Device IP (wlan0): $ip"
    else
        echo "Could not detect device IP on wlan0. Is Wi-Fi connected?"
        return 1
    fi
}

# Capture high-res screenshot directly from device to local file
function adb-screenshot() {
    local filename="${1:-screenshot-$(date +%Y%m%d-%H%M%S).png}"
    adb exec-out screencap -p > "$filename"
    if [ -s "$filename" ]; then
        echo "Saved screenshot to: $filename"
    else
        echo "Failed to capture screenshot."
        rm -f "$filename"
        return 1
    fi
}

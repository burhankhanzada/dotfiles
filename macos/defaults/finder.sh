#!/usr/bin/env bash

# Fallback for echo helpers if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

function finder_clean_desktop() {
    echo.Green "  Hide all desktop icons and external drives"
    defaults write com.apple.finder CreateDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
}

function finder_show_extensions() {
    echo.Green "  Show all filename extensions"
    defaults write -g AppleShowAllExtensions -bool true
}

function finder_show_pathbar() {
    echo.Green "  Show path bar, status bar, and tab bar"
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowTabBar -bool true
    sudo chflags nohidden /Volumes 2>/dev/null || true
}

function finder_folders_on_top() {
    echo.Green "  Keep folders on top when sorting by name"
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
}

function finder_search_current_folder() {
    echo.Green "  Set default search scope to current folder"
    defaults write com.apple.finder FXDefaultSearchScope -string SCcf
}

function finder_show_hidden() {
    echo.Green "  Show hidden files"
    defaults write com.apple.finder AppleShowAllFiles -bool true
}

function finder_disable_trash_warning() {
    echo.Green "  Disable empty trash warning and sound"
    defaults write com.apple.Finder FinderSounds -bool false
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
}

function finder_disable_extension_warning() {
    echo.Green "  Disable warning when changing a file extension"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
}

function finder_disable_quarantine() {
    echo.Green "  Disable 'Are you sure you want to open this application?' quarantine dialog"
    defaults write com.apple.LaunchServices LSQuarantine -bool false
}

function finder_no_ds_store_usb_network() {
    echo.Green "  Disable creating .DS_Store files on network & USB volumes"
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
}

function finder_expand_save_panels() {
    echo.Green "  Expand save panel by default"
    defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
    defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
}

function finder_sidebar_clean() {
    echo.Green "  Configure clean Finder sidebar"
    defaults write com.apple.finder SidebarWidth -int 160
    defaults write com.apple.finder ShowRecentTags -bool false
    defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool false
    defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool false
}

echo.Green "==> Configuring Finder & Desktop Defaults"

if [ $# -gt 0 ]; then
    for fn in "$@"; do
        [[ "$fn" != finder_* ]] && fn="finder_$fn"
        if declare -f "$fn" >/dev/null; then
            "$fn"
        fi
    done
else
    if [ -n "$ZSH_VERSION" ]; then
        funcs=(${(f)"$(print -l ${(ok)functions[(I)finder_*]} | sort)"})
    else
        funcs=($(compgen -A function finder_ | sort))
    fi
    for fn in "${funcs[@]}"; do
        "$fn"
    done
fi

killall Finder 2>/dev/null || true

#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

function _is_disable() {
    [[ "$1" == "false" || "$1" == "off" || "$1" == "disable" || "$1" == "0" ]]
}

function finder_clean_desktop() {
    if _is_disable "$1"; then
        echo.Yellow "  Show desktop icons and external drives"
        defaults write com.apple.finder CreateDesktop -bool true
        defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
        defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    else
        echo.Green "  Hide all desktop icons and external drives"
        defaults write com.apple.finder CreateDesktop -bool false
        defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
        defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    fi
}

function finder_show_extensions() {
    if _is_disable "$1"; then
        echo.Yellow "  Hide filename extensions by default"
        defaults write -g AppleShowAllExtensions -bool false
    else
        echo.Green "  Show all filename extensions"
        defaults write -g AppleShowAllExtensions -bool true
    fi
}

function finder_show_pathbar() {
    if _is_disable "$1"; then
        echo.Yellow "  Hide path bar, status bar, and tab bar"
        defaults write com.apple.finder ShowPathbar -bool false
        defaults write com.apple.finder ShowStatusBar -bool false
        defaults write com.apple.finder ShowTabBar -bool false
    else
        echo.Green "  Show path bar, status bar, and tab bar"
        defaults write com.apple.finder ShowPathbar -bool true
        defaults write com.apple.finder ShowStatusBar -bool true
        defaults write com.apple.finder ShowTabBar -bool true
        sudo chflags nohidden /Volumes 2>/dev/null || true
    fi
}

function finder_folders_on_top() {
    if _is_disable "$1"; then
        echo.Yellow "  Do not keep folders on top when sorting"
        defaults write com.apple.finder _FXSortFoldersFirst -bool false
    else
        echo.Green "  Keep folders on top when sorting by name"
        defaults write com.apple.finder _FXSortFoldersFirst -bool true
    fi
}

function finder_search_current_folder() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset default search scope to This Mac"
        defaults delete com.apple.finder FXDefaultSearchScope 2>/dev/null || true
    else
        echo.Green "  Set default search scope to current folder"
        defaults write com.apple.finder FXDefaultSearchScope -string SCcf
    fi
}

function finder_show_hidden() {
    if _is_disable "$1"; then
        echo.Yellow "  Hide hidden files"
        defaults write com.apple.finder AppleShowAllFiles -bool false
    else
        echo.Green "  Show hidden files"
        defaults write com.apple.finder AppleShowAllFiles -bool true
    fi
}

function finder_disable_trash_warning() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable empty trash warning and sound"
        defaults write com.apple.Finder FinderSounds -bool true
        defaults write com.apple.finder WarnOnEmptyTrash -bool true
    else
        echo.Green "  Disable empty trash warning and sound"
        defaults write com.apple.Finder FinderSounds -bool false
        defaults write com.apple.finder WarnOnEmptyTrash -bool false
    fi
}

function finder_disable_extension_warning() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable warning when changing a file extension"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true
    else
        echo.Green "  Disable warning when changing a file extension"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    fi
}

function finder_disable_quarantine() {
    if _is_disable "$1"; then
        echo.Yellow "  Enable application quarantine dialog"
        defaults write com.apple.LaunchServices LSQuarantine -bool true
    else
        echo.Green "  Disable 'Are you sure you want to open this application?' quarantine dialog"
        defaults write com.apple.LaunchServices LSQuarantine -bool false
    fi
}

function finder_no_ds_store_usb_network() {
    if _is_disable "$1"; then
        echo.Yellow "  Allow creating .DS_Store files on network & USB volumes"
        defaults delete com.apple.desktopservices DSDontWriteUSBStores 2>/dev/null || true
        defaults delete com.apple.desktopservices DSDontWriteNetworkStores 2>/dev/null || true
    else
        echo.Green "  Disable creating .DS_Store files on network & USB volumes"
        defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    fi
}

function finder_expand_save_panels() {
    if _is_disable "$1"; then
        echo.Yellow "  Collapse save panel by default"
        defaults delete -g NSNavPanelExpandedStateForSaveMode 2>/dev/null || true
        defaults delete -g NSNavPanelExpandedStateForSaveMode2 2>/dev/null || true
    else
        echo.Green "  Expand save panel by default"
        defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
        defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true
    fi
}

function finder_sidebar_clean() {
    if _is_disable "$1"; then
        echo.Yellow "  Reset Finder sidebar settings"
        defaults write com.apple.finder ShowRecentTags -bool true
        defaults delete com.apple.finder SidebarWidth 2>/dev/null || true
    else
        echo.Green "  Configure clean Finder sidebar"
        defaults write com.apple.finder SidebarWidth -int 160
        defaults write com.apple.finder ShowRecentTags -bool false
        defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool false
        defaults write com.apple.finder SidebariCloudDriveSectionDisclosedState -bool false
    fi
}

echo.Green "==> Configuring Finder & Desktop Defaults"
run_defaults_functions "finder" "$@"

killall Finder 2>/dev/null || true

#!/usr/bin/env bash

export MAC_OS_PATH=$DOTFILES/mac_os

continueAbortSourceFile 'Reset MacOS Defaults?' $MAC_OS_PATH/reset_defaults.sh
continueAbortSourceFile 'Set MacOS Defaults?' $MAC_OS_PATH/set_defaults.sh

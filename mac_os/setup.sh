#!/usr/bin/env bash

macos_path=$DOTFILES/mac_os

continueAbort 'Reset MacOS Defaults' $macos_path/reset_defaults.sh
continueAbort 'Set MacOS Defaults' $macos_path/set_defaults.sh

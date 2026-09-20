#!/usr/bin/env bash

android="${DEVELOPMENT:-$HOME/Development}/Google/Android"

if [ -d "$android" ]; then
    symlink "$android/.gradle" "$HOME/.gradle"
    symlink "$android/.android" "$HOME/.android"
    symlink "$android/sdk" "$HOME/Library/Android/sdk"
fi

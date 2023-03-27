#!/usr/bin/env bash

brew install android-studio

export GOOGLE_PATH="$DEVELOPMENT/Google"
export ANDROID_PATH="$GOOGLE_PATH/Android"

echo 'export ANDROID_HOME="$ANDROID_PATH/sdk"' >>~/.zshenv
echo 'export ANDROID_USER_HOME="$ANDROID_PATH/.android"' >>~/.zshenv
echo 'export ANDROID_PREFS_ROOT="$ANDROID_PATH/android"' >>~/.zshenv
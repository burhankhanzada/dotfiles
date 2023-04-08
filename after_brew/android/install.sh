#!/usr/bin/env bash

brew install android-studio

export GOOGLE_PATH="$DEVELOPMENT/Google"
export ANDROID_PATH="$GOOGLE_PATH/Android"

sdk="$ANDROID_PATH/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

echo "path+=$tools" >>~/.zshrc
echo "path+=$cmdline_tools" >>~/.zshrc
echo "path+=$platform_tools" >>~/.zshrc
echo "export PATH" >>~/.zshrc

# echo 'export ANDROID_HOME="$sdk"' >>~/.zshenv
# echo 'export ANDROID_USER_HOME="$ANDROID_PATH/.android"' >>~/.zshenv
# echo 'export ANDROID_PREFS_ROOT="$ANDROID_PATH/android"' >>~/.zshenv

#!/usr/bin/env bash

brew install android-studio

export ANDROID_PATH=$DEVELOPMENT/Google/Android

sdk="$ANDROID_PATH/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

echo "path+=$tools" >>~/.zshrc
echo "path+=$cmdline_tools" >>~/.zshrc
echo "path+=$platform_tools" >>~/.zshrc
echo "export PATH" >>~/.zshrc

#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

echo "path+=$tools" >>~/.zshrc
echo "path+=$cmdline_tools" >>~/.zshrc
echo "path+=$platform_tools" >>~/.zshrc
echo "export PATH" >>~/.zshrc
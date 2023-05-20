#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

echo "path+=$tools" >>$HOME/.zshrc
echo "path+=$cmdline_tools" >>$HOME/.zshrc
echo "path+=$platform_tools" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc
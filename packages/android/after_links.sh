#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"

tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

jbr_bin="Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin"

echo "path+=$tools" >>$HOME/.zshrc
echo "path+=$cmdline_tools" >>$HOME/.zshrc
echo "path+=$platform_tools" >>$HOME/.zshrc
echo "path+=$jbr_bin" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc
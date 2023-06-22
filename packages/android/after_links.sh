#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"
jbr_bin="Applications/Android\ Studio.app/Contents/jbr/Contents/Home/bin"

echo '' >>$HOME/.zshrc
echo 'export PATH='"$tools"':$PATH' >>$HOME/.zshrc
echo 'export PATH='"$cmdline_tools"':$PATH' >>$HOME/.zshrc
echo 'export PATH='"$platform_tools"':$PATH' >>$HOME/.zshrc
echo 'export PATH='"$jbr_bin"':$PATH' >>$HOME/.zshrc

source $HOME/.zshrc
#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"
jbr_bin="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"

if ! grep -qs "# Android start" "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# Android start' >> "$HOME/.zshrc"
    echo "export PATH=\"$tools:\$PATH\"" >> "$HOME/.zshrc"
    echo "export PATH=\"$cmdline_tools:\$PATH\"" >> "$HOME/.zshrc"
    echo "export PATH=\"$platform_tools:\$PATH\"" >> "$HOME/.zshrc"
    echo "export PATH=\"$jbr_bin:\$PATH\"" >> "$HOME/.zshrc"
    echo '# Android end' >> "$HOME/.zshrc"
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

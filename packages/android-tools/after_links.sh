#!/usr/bin/env bash

sdk="$HOME/Library/Android/sdk"
tools="$sdk/tools"
cmdline_tools="$sdk/cmdline-tools/latest/bin:$sdk/cmdline-tools"
platform_tools="$sdk/platform-tools"

# Clean up legacy Android blocks if present
if [ -f "$HOME/.zshrc" ]; then
    if grep -qs "# Android start" "$HOME/.zshrc" 2>/dev/null; then
        sed -i '' '/# Android start/,/# Android end/d' "$HOME/.zshrc"
    fi
    if grep -qs "# Android Tools start" "$HOME/.zshrc" 2>/dev/null; then
        sed -i '' '/# Android Tools start/,/# Android Tools end/d' "$HOME/.zshrc"
    fi
fi

echo '' >> "$HOME/.zshrc"
echo '# Android Tools start' >> "$HOME/.zshrc"
echo "export ANDROID_HOME=\"$sdk\"" >> "$HOME/.zshrc"
echo "export ANDROID_USER_HOME=\"$HOME/.android\"" >> "$HOME/.zshrc"
echo "export PATH=\"$platform_tools:\$PATH\"" >> "$HOME/.zshrc"
echo "export PATH=\"$cmdline_tools:\$PATH\"" >> "$HOME/.zshrc"
echo "export PATH=\"$tools:\$PATH\"" >> "$HOME/.zshrc"
echo 'if [ -n "$ZSH_VERSION" ] && type compdef &>/dev/null && command -v android &>/dev/null; then' >> "$HOME/.zshrc"
echo '    eval "$(android completion zsh 2>/dev/null)"' >> "$HOME/.zshrc"
echo 'fi' >> "$HOME/.zshrc"
echo '# Android Tools end' >> "$HOME/.zshrc"

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

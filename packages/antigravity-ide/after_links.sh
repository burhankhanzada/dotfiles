#!/usr/bin/env bash

# Antigravity IDE CLI binary path
app_bin="/Applications/Antigravity IDE.app/Contents/Resources/app/bin"

if [ -d "$app_bin" ]; then
    if ! grep -qs "# Antigravity IDE start" "$HOME/.zshrc" 2>/dev/null; then
        echo '' >> "$HOME/.zshrc"
        echo '# Antigravity IDE start' >> "$HOME/.zshrc"
        echo "export PATH=\"$app_bin:\$PATH\"" >> "$HOME/.zshrc"
        echo '# Antigravity IDE end' >> "$HOME/.zshrc"
    fi
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

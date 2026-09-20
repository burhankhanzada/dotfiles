#!/usr/bin/env bash

# Android Studio bundled JBR (Java Runtime)
jbr_bin="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"

if [ -d "$jbr_bin" ]; then
    if ! grep -qs "# Android Studio start" "$HOME/.zshrc" 2>/dev/null; then
        echo '' >> "$HOME/.zshrc"
        echo '# Android Studio start' >> "$HOME/.zshrc"
        echo "export PATH=\"$jbr_bin:\$PATH\"" >> "$HOME/.zshrc"
        echo '# Android Studio end' >> "$HOME/.zshrc"
    fi
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

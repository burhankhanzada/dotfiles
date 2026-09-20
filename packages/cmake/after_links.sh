#!/usr/bin/env bash

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

if ! grep -qs "# Cmake start" "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# Cmake start' >> "$HOME/.zshrc"
    echo "export PATH=\"$BREW_PREFIX/opt/make/libexec/gnubin:\$PATH\"" >> "$HOME/.zshrc"
    echo '# Cmake end' >> "$HOME/.zshrc"
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

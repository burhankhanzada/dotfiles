#!/usr/bin/env bash

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

export LDFLAGS="-L$BREW_PREFIX/opt/llvm/lib"
export CPPFLAGS="-I$BREW_PREFIX/opt/llvm/include"

if ! grep -qs "# LLVM start" "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# LLVM start' >> "$HOME/.zshrc"
    echo "export PATH=\"$BREW_PREFIX/opt/llvm/bin:\$PATH\"" >> "$HOME/.zshrc"
    echo '# LLVM end' >> "$HOME/.zshrc"
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

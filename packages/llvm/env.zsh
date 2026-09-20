#!/usr/bin/env zsh
# LLVM & Clang compiler toolchain environment configuration.

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

if [ -d "$BREW_PREFIX/opt/llvm" ]; then
    export PATH="$BREW_PREFIX/opt/llvm/bin:$PATH"
    export LDFLAGS="-L$BREW_PREFIX/opt/llvm/lib ${LDFLAGS}"
    export CPPFLAGS="-I$BREW_PREFIX/opt/llvm/include ${CPPFLAGS}"
fi

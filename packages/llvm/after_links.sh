#!/usr/bin/env bash

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

echo '' >>$HOME/.zshrc

echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >>$HOME/.zshrc

source $HOME/.zshrc


#!/usr/bin/env bash

sudo xcode-select -r

brew install python-tk

brew install pyenv
brew install jupyterlab

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

if ! grep -qs "PYENV_ROOT" "$HOME/.zshenv" 2>/dev/null; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.zshenv"
fi

if ! grep -qs "pyenv init" "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.zshrc"
    echo 'eval "$(pyenv init -)"' >> "$HOME/.zshrc"
    echo "alias python=\"$BREW_PREFIX/bin/python3\"" >> "$HOME/.zshrc"
fi

version="3.13.5"

if command -v pyenv &>/dev/null; then
    pyenv install -s "$version"
    pyenv global "$version"
fi
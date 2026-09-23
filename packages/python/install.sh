#!/usr/bin/env bash
# Python, pyenv, and JupyterLab installation.

sudo xcode-select -r 2>/dev/null || true

brew install python-tk
brew install pyenv
brew install jupyterlab

version="3.13.5"

if command -v pyenv &>/dev/null; then
    pyenv install -s "$version"
    pyenv global "$version"
fi

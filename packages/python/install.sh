#!/usr/bin/env bash

sudo xcode-select -r

brew install python-tk

brew install pyenv
brew install jupyterlab

echo '' >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshenv
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo "alias python=/opt/homebrew/bin/python3" >> ~/.zshrc

version="3.13.5"

pyenv install $version
pyenv global $version
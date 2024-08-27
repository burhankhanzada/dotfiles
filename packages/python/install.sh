#!/usr/bin/env bash

sudo xcode-select -r

brew install python-tk

brew install pyenv
brew install jupyterlab

echo '' >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zenv
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

version="3.12.5"

pyenv install $version
pyenv global $version
#!/usr/bin/env bash

sudo xcode-select -r

brew install pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

PYHTON_VERSION="3.10.10"

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

export PYTHON_PATH=$DEVELOPMENT/Python
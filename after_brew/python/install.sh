#!/usr/bin/env bash

sudo xcode-select -r

brew install pyenv

# echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.zshrc
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.zshrc
# echo "eval $(pyenv init --path)" >>~/.zprofile

PYHTON_VERSION=3.10.10

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

export PYHTON_PATH="$DEVELOPMENT/Python"
echo 'export NLTK_DATA="$PYHTON_PATH/nltk"' >>~/.zshrc

#!/usr/bin/env bash

sudo xcode-select -r

brew install pyenv

# echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.zshenv
# echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.zshenv
echo "eval $(pyenv init --path)" >>~/.zprofile

eval $(pyenv init --path)

PYHTON_VERSION=3.10.10

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

# export PYHTON_PATH="$DEVELOPMENT/Python"
# export NLTK_DATA="$PYHTON_PATH/nltk"

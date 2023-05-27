#!/usr/bin/env bash

sudo xcode-select -r

brew install pyenv

echo "eval $(pyenv init --path)" >>~/.zprofile
eval $(pyenv init --path)

PYHTON_VERSION=3.10.10

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

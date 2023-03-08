#!/usr/bin/env bash

echo ''
echo 'Installing python'

export PYHTON_VERSION=3.10.10

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

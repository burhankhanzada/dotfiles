#!/usr/bin/env bash

echo ""
echo "Installing python"

export PYHTON_VERSION=3.10.10

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install $PYHTON_VERSION
pyenv global $PYHTON_VERSION

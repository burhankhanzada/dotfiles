#!/usr/bin/env bash

python=$DEVELOPMENT/Python

symlink $python/.pyenv $HOME/.pyenv
symlink $python/.ipython $HOME/.ipython
symlink $python/.matplotlib $HOME/.matplotlib
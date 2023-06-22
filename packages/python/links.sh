#!/usr/bin/env bash

python=$DEVELOPMENT/Python

link_file $python/.pyenv $HOME/.pyenv
link_file $python/.ipython $HOME/.ipython
link_file $python/.matplotlib $HOME/.matplotlib
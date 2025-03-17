#!/usr/bin/env bash

echo '' >>$HOME/.zshrc

echo 'export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"' >>$HOME/.zshrc

source $HOME/.zshrc


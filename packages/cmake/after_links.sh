#!/usr/bin/env bash

echo '' >>$HOME/.zshrc
echo '# Cmake start' >>$HOME/.zshrc
echo 'export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"' >>$HOME/.zshrc
echo '# Cmake end' >>$HOME/.zshrc

reld

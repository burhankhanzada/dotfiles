#!/usr/bin/env bash

brew install visual-studio-code

echo 'export EDITOR="code"' >>$HOME/.zshenv

source $HOME/.zshenv

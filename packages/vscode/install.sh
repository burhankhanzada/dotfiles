#!/usr/bin/env bash

brew install visual-studio-code

dockutil --add "/Applications/Visual Studio Code.app"

export EDITOR="code"

echo 'export EDITOR="code"' >>$HOME/.zshenv

source $HOME/.zshenv

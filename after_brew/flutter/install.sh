#!/usr/bin/env bash

brew tap leoafarias/fvm
brew install fvm

fvm install stable --verbose

export GOOGLE_PATH="$DEVELOPMENT/Google"
export FLUTTER_PATH="$GOOGLE_PATH/Flutter"

# echo 'export FVM_HOME="$FLUTTER_PATH/fvm"' >>~/.zshrc

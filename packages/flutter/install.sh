#!/usr/bin/env bash

# https://github.com/fluttertools/fvm

sudo softwareupdate --install-rosetta --agree-to-license

brew tap leoafarias/fvm
brew install fvm

dart pub global activate fvm
dart pub global activate flutter_gen

export FLUTTER_PATH=$DEVELOPMENT/Google/Flutter

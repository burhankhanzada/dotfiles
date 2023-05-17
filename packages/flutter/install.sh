#!/usr/bin/env bash

# https://github.com/fluttertools/fvm

brew tap leoafarias/fvm
brew install fvm

fvm install stable

dart pub global activate fvm
dart pub global activate flutter_gen

export FLUTTER_PATH=$DEVELOPMENT/Google/Flutter

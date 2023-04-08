#!/usr/bin/env bash

# https://github.com/fluttertools/fvm

brew tap leoafarias/fvm
brew install fvm

fvm install stable

dart pub global activate fvm

# export GOOGLE_PATH="$DEVELOPMENT/Google"
# export ANDROID_PATH="$GOOGLE_PATH/Android"
# export FLUTTER_PATH="$GOOGLE_PATH/Flutter"

# fvm flutter config --android-sdk $ANDROID_PATH/sdk

#!/usr/bin/env bash

brew tap leoafarias/fvm
brew install fvm

fvm install stable
fvm use stable

export GOOGLE_PATH="$DEVELOPMENT/Google"
export ANDROID_PATH="$GOOGLE_PATH/Android"

fvm flutter config --android-sdk $ANDROID_PATH/sdk

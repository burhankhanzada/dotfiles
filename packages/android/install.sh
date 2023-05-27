#!/usr/bin/env bash

continueAbortCommand "brew install scrcpy"
continueAbortCommand "brew install android-studio"

dockutil --add "/Applications/Android Studio.app"

export ANDROID_PATH=$DEVELOPMENT/Google/Android


#!/usr/bin/env bash

android=$DEVELOPMENT/Google/Android

symlink $android/.gradle $HOME/.gradle
symlink $android/.android $HOME/.android
symlink $android/sdk $HOME/Library/Android/sdk
#!/usr/bin/env bash

android=$DEVELOPMENT/Google/Android

link_file $android/.gradle $HOME/.gradle
link_file $android/.android $HOME/.android
link_file $android/sdk $HOME/Library/Android/sdk
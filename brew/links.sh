#!/usr/bin/env bash

export HOMEBREW_PATH=$DEVELOPMENT/Homebrew

link_file $HOMEBREW_PATH/Caches/Homebrew $HOME/Library/Caches/Homebrew
link_file $HOMEBREW_PATH/opt/homebrew /opt/homebrew
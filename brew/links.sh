#!/usr/bin/env bash

export HOMEBREW_PATH=$DEVELOPMENT/Homebrew

symlink $HOMEBREW_PATH/Caches/Homebrew $HOME/Library/Caches/Homebrew
symlink $HOMEBREW_PATH/opt/homebrew /opt/homebrew
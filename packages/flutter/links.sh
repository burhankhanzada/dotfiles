#!/usr/bin/env bash

flutter=$DEVELOPMENT/Google/Flutter

symlink $flutter/fvm $HOME/fvm
symlink $flutter/.dart $HOME/.dart
symlink $flutter/.dart-tool $HOME/.dart-tool
symlink $flutter/.pub-cache $HOME/.pub-cache
symlink $flutter/.dartserver $HOME/.dartserver
#!/usr/bin/env bash

flutter=$DEVELOPMENT/Google/Flutter

link_file $flutter/fvm $HOME/fvm
link_file $flutter/.dart $HOME/.dart
link_file $flutter/.dart-tool $HOME/.dart-tool
link_file $flutter/.pub-cache $HOME/.pub-cache
link_file $flutter/.dartserver $HOME/.dartserver
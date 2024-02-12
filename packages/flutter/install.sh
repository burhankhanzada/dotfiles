#!/usr/bin/env bash

# sudo softwareupdate --install-rosetta --agree-to-license

# https://github.com/fluttertools/fvm

# git clone https://github.com/cbracken/dvm.git ~/.dvm

brew tap leoafarias/fvm
brew install fvm

continueAbortCommand "fvm install stable"
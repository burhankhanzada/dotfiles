#!/usr/bin/env bash

# sudo softwareupdate --install-rosetta --agree-to-license

# https://github.com/fluttertools/fvm

brew tap leoafarias/fvm
brew install fvm

continueAbortCommand "fvm install stable"
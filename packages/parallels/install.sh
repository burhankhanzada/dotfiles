#!/usr/bin/env bash

sudo xcodebuild -license accept

brew install parallels
brew install parallels-toolbox

continueAbortCommand "brew install parallels-access"

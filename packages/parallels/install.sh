#!/usr/bin/env bash

sudo xcodebuild -license accept

# Prarallels
continueAbortCommand "brew install parallels"
continueAbortCommand "brew install parallels-access"
continueAbortCommand "brew install parallels-toolbox"

dockutil --add "/Applications/Parallels Desktop.app"

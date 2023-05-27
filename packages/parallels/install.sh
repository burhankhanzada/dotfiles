#!/usr/bin/env bash

# Prarallels
continueAbortCommand "brew install parallels"
continueAbortCommand "brew install parallels-access"
continueAbortCommand "brew install parallels-toolbo"

dockutil --add "/Applications/Parallels Desktop.app"

#!/usr/bin/env bash

sudo softwareupdate --install-rosetta --agree-to-license

sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'

sudo xcodebuild -license
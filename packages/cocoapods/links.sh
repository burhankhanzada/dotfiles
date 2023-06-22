#!/usr/bin/env bash

cocoaPods=$DEVELOPMENT/CocoaPods

symlink $cocoaPods/.cocoapods $HOME/.cocoapods
symlink $cocoaPods/CocoaPods $HOME/Library/Caches/CocoaPods
#!/usr/bin/env bash

DEVELOPMENT=~/Development

# VSCode
ln -F -s "$DEVELOPMENT/Microsoft/.vscode" ~/.vscode

# Android
ln -F -s "$DEVELOPMENT/Google/Gradle/.gradle" ~/.gradle

ln -F -s "$DEVELOPMENT/Google/Android/.android" ~/.android

mkdir -p ~/Library/Android
ln -F -s "$DEVELOPMENT/Google/Android/sdk" ~/Library/Android/sdk

# Flutter
ln -F -s "$DEVELOPMENT/Google/Flutter/.dart" ~/.dart
ln -F -s "$DEVELOPMENT/Google/Flutter/.config" ~/.config
ln -F -s "$DEVELOPMENT/Google/Flutter/.dartserver" ~/.dartserver
ln -F -s "$DEVELOPMENT/Google/Flutter/.pub-cache" ~/.pub-cache

sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

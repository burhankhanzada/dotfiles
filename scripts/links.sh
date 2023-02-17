#!/usr/bin/env bash

DEVELOPMENT=~/Development

echo ''
info 'Setting symbolic links for dicrectories'

# Warp
ln -sfnv "$DEVELOPMENT/.warp" ~/.warp

# Cache
ln -sfnv "$DEVELOPMENT/.cache" ~/.cache

# VSCode
ln -sfnv "$DEVELOPMENT/Microsoft/.vscode" ~/.vscode

# Android
ln -sfnv "$DEVELOPMENT/Google/Gradle/.gradle" ~/.gradle

ln -sfnv "$DEVELOPMENT/Google/Android/.android" ~/.android

mkdir -p ~/Library/Android
ln -sfnv "$DEVELOPMENT/Google/Android/sdk" ~/Library/Android/sdk

# Flutter
ln -sfnv "$DEVELOPMENT/Google/Flutter/.dart" ~/.dart
ln -sfnv "$DEVELOPMENT/Google/Flutter/.config" ~/.config
ln -sfnv "$DEVELOPMENT/Google/Flutter/.dartserver" ~/.dartserver
ln -sfnv "$DEVELOPMENT/Google/Flutter/.pub-cache" ~/.pub-cache

sudo ln -sfnv /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

#!/usr/bin/env bash

DEVELOPMENT=~/development

ln -F -s "$DEVELOPMENT/microsoft/.vscode" ~/.vscode

ln -F -s "$DEVELOPMENT/google/.android" ~/.android

mkdir -p ~/Library/Android
ln -F -s "$DEVELOPMENT/google/android-sdk" ~/Library/Android/sdk

sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

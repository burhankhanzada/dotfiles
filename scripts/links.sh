#!/usr/bin/env bash

echo ''
echo 'Setting symbolic links for dicrectories'

DOTFILES=~/.dotfiles

# ZSH
ln -sfnv "$DOTFILES/zsh/.zprofile" ~/.zprofile
ln -sfnv "$DOTFILES/zsh/.zshenv" ~/.zshenv
ln -sfnv "$DOTFILES/zsh/.zshrc" ~/.zshrc

# Git
ln -sfnv "$DOTFILES/git/.gitconfig" ~/.gitconfig
ln -sfnv "$DOTFILES/git/.gitignore" ~/.gitignore
ln -sfnv "$DOTFILES/git/.gitconfig.local" ~/.gitconfig.local

DEVELOPMENT=~/Development

# Warp
ln -sfnv "$DEVELOPMENT/.warp" ~/.warp

# Cache
ln -sfnv "$DEVELOPMENT/.cache" ~/.cache

# Cocoapods
ln -sfnv "$DEVELOPMENT/.cocoapods" ~/.cocoapods

# VSCode
ln -sfnv "$DEVELOPMENT/Microsoft/.vscode" ~/.vscode

# Gradle
ln -sfnv "$DEVELOPMENT/Google/Gradle/.gradle" ~/.gradle

# Android
mkdir -p ~/Library/Android
ln -sfnv "$DEVELOPMENT/Google/Android/.android" ~/.android
ln -sfnv "$DEVELOPMENT/Google/Android/sdk" ~/Library/Android/sdk

# Flutter
ln -sfnv "$DEVELOPMENT/Google/Flutter/.dart" ~/.dart
ln -sfnv "$DEVELOPMENT/Google/Flutter/.config" ~/.config
ln -sfnv "$DEVELOPMENT/Google/Flutter/.dartserver" ~/.dartserver
ln -sfnv "$DEVELOPMENT/Google/Flutter/.pub-cache" ~/.pub-cache

sudo ln -sfnv /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

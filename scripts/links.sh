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

# Wine
ln -sfnv "$DEVELOPMENT/.wine" ~/.wine

# Wine
ln -sfnv "$DEVELOPMENT/Parallels" ~/Parallels

# Cache
ln -sfnv "$DEVELOPMENT/.cache" ~/.cache

# VSCode
ln -sfnv "$DEVELOPMENT/.vscode" ~/.vscode

# Gradle
ln -sfnv "$DEVELOPMENT/.gradle" ~/.gradle

# Homebrew
ln -sfnv "$DEVELOPMENT/Homebrew" ~/Library/Caches/Homebrew

# Ruby
ln -sfnv "$DEVELOPMENT/Ruby/.gem" ~/.gem
ln -sfnv "$DEVELOPMENT/Ruby/.rubies" ~/.rubies
ln -sfnv "$DEVELOPMENT/Ruby/src" ~/src

# CocoaPods
ln -sfnv "$DEVELOPMENT/CocoaPods/.cocoapods" ~/.cocoapods
ln -sfnv "$DEVELOPMENT/CocoaPods/CocoaPods" ~/Library/Caches/CocoaPods

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

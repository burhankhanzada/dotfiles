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

function link_if_exist() {

    source=$1
    destination=$2

    echo ''

    if [[ $(readlink $destination) ]]; then
        echo "Link already exsit for $destination"
    elif [[ -d $destination ]]; then
        echo "Direcotry exsits $destination"
        mv $destination $source
        ln -sfnv $source $destination
    elif [[ -f $destination ]]; then
        echo "File exsits $destination"
        mv $destination $source
        ln -sfnv $source $destination
    fi
}

# Warp
link_if_exist "$DEVELOPMENT/.warp" ~/.warp

# Wine
link_if_exist "$DEVELOPMENT/.wine" ~/.wine

# Pyenv
link_if_exist "$DEVELOPMENT/.pyenv" ~/.pyenv

# Cache
link_if_exist "$DEVELOPMENT/.cache" ~/.cache

# Gradle
link_if_exist "$DEVELOPMENT/.gradle" ~/.gradle

# VSCode
link_if_exist "$DEVELOPMENT/.vscode" ~/.vscode

# Parallels
link_if_exist "$DEVELOPMENT/Parallels" ~/Parallels

# Homebrew
link_if_exist "$DEVELOPMENT/Homebrew" ~/Library/Caches/Homebrew

# Ruby
link_if_exist "$DEVELOPMENT/Ruby/.gem" ~/.gem
link_if_exist "$DEVELOPMENT/Ruby/.rubies" ~/.rubies
link_if_exist "$DEVELOPMENT/Ruby/src" ~/src

# CocoaPods
link_if_exist "$DEVELOPMENT/CocoaPods/.cocoapods" ~/.cocoapods
link_if_exist "$DEVELOPMENT/CocoaPods/CocoaPods" ~/Library/Caches/CocoaPods

# Android
mkdir -p ~/Library/Android
link_if_exist "$DEVELOPMENT/Google/Android/.android" ~/.android
link_if_exist "$DEVELOPMENT/Google/Android/sdk" ~/Library/Android/sdk

# Flutter
link_if_exist "$DEVELOPMENT/Google/Flutter/.dart" ~/.dart
link_if_exist "$DEVELOPMENT/Google/Flutter/.config" ~/.config
link_if_exist "$DEVELOPMENT/Google/Flutter/.dartserver" ~/.dartserver
link_if_exist "$DEVELOPMENT/Google/Flutter/.pub-cache" ~/.pub-cache

link_if_exist /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

#!/usr/bin/env bash

echo ""
echo "Setting symbolic links for dicrectories"

DOTFILES=~/.dotfiles

function link_if_exist() {

    source=$1
    destination=$2

    output=$(readlink $destination)

    if [[ $output ]]; then
        echo "Link already exsit for $destination -> $source"

        if [[ $output != $source ]]; then
            ln -sfnv $source $destination
            echo "Link updated to new Source: \"$source\""
        fi

    else

        if [[ -e $destination ]]; then
            echo "Desnation: \"$destination\" exists"

            # TODO check if link to ba a file then move command dosent work bcz
            # TODO target need a directory  path but have a file path neeed to
            # TODO extract target path from $source path below commented code is
            # TODO not working properly

            # parentdir=$(
            #     builtin cd $source
            #     pwd
            # )
            # echo $parentdir

            mv $destination $source

            echo "Desnation: \"$destination\" moved to Source: \"$source\""
            ln -sfnv $source $destination
            echo "New Link created"
        else

            if [[ -e $source ]]; then
                echo "Source: \"$source\" exists"
                ln -sfnv $source $destination
                echo "New Link created"
            fi

        fi

    fi
}

# ZSH
ln -sfnv $DOTFILES/zsh/.zprofile ~/.zprofile
ln -sfnv $DOTFILES/zsh/.zshenv ~/.zshenv
ln -sfnv $DOTFILES/zsh/.zshrc ~/.zshrc

# Git
ln -sfnv $DOTFILES/git/.gitconfig ~/.gitconfig
ln -sfnv $DOTFILES/git/.gitignore ~/.gitignore
ln -sfnv $DOTFILES/git/.gitconfig.local ~/.gitconfig.local

DEVELOPMENT=~/Development

# Warp
link_if_exist $DEVELOPMENT/.warp ~/.warp

# Wine
link_if_exist $DEVELOPMENT/.wine ~/.wine

# Cache
link_if_exist $DEVELOPMENT/.cache ~/.cache

# Gradle
link_if_exist $DEVELOPMENT/.gradle ~/.gradle

# Parallels
link_if_exist $DEVELOPMENT/Parallels ~/Parallels

# Pyenv
link_if_exist $DEVELOPMENT/Python/.pyenv ~/.pyenv

# VSCode
link_if_exist $DEVELOPMENT/VSCode/.vscode ~/.vscode

# Homebrew
link_if_exist $DEVELOPMENT/Homebrew ~/Library/Caches/Homebrew

# Ruby
link_if_exist $DEVELOPMENT/Ruby/src ~/src
link_if_exist $DEVELOPMENT/Ruby/.gem ~/.gem
link_if_exist $DEVELOPMENT/Ruby/.rubies ~/.rubies

# CocoaPods
link_if_exist $DEVELOPMENT/CocoaPods/.cocoapods ~/.cocoapods
link_if_exist $DEVELOPMENT/CocoaPods/CocoaPods ~/Library/Caches/CocoaPods

# Android
mkdir -p ~/Library/Android
link_if_exist $DEVELOPMENT/Google/Android/.android ~/.android
link_if_exist $DEVELOPMENT/Google/Android/sdk ~/Library/Android/sdk

# Flutter
link_if_exist $DEVELOPMENT/Google/Flutter/.dart ~/.dart
link_if_exist $DEVELOPMENT/Google/Flutter/.config ~/.config
link_if_exist $DEVELOPMENT/Google/Flutter/.pub-cache ~/.pub-cache
link_if_exist $DEVELOPMENT/Google/Flutter/.dartserver ~/.dartserver

link_if_exist /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

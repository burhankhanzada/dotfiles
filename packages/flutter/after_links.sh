#!/usr/bin/env bash

fvm install stable

fvm_path=$HOME/fvm

pub_cache="$HOME/.pub-cache/bin"
sdk_default=$fvm_path/default/bin
sdk_stable=$fvm_path/versions/stable/bin

echo "path+=$pub_cache" >>$HOME/.zshrc
echo "path+=$sdk_stable" >>$HOME/.zshrc
echo "path+=$sdk_default" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc
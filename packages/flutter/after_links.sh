#!/usr/bin/env bash

dart pub global activate fvm
dart pub global activate flutter_gen

fvm install stable

pub_cache="$HOME/.pub-cache/bin"

fvm_path=$HOME/fvm

sdk_stable=$fvm_path/versions/stable
sdk_stable_bin=$sdk_stable/bin

echo "path+=$sdk_stable" >>$HOME/.zshrc
echo "path+=$sdk_stable_bin" >>$HOME/.zshrc
echo "path+=$pub_cache" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc
#!/usr/bin/env bash

continueAbortCommand "fvm install stable"


fvm_path=$HOME/fvm

sdk_stable=$fvm_path/versions/stable
sdk_stable_bin=$sdk_stable/bin

pub_cache_bin="$HOME/.pub-cache/bin"

echo "path+=$sdk_stable" >>$HOME/.zshrc
echo "path+=$sdk_stable_bin" >>$HOME/.zshrc
echo "path+=$pub_cache_bin" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc

dart pub global activate fvm
dart pub global activate flutter_gen
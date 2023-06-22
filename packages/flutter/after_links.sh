#!/usr/bin/env bash

pub_cache_bin=$HOME/.pub-cache/bin
stable_bin=$HOME/fvm/versions/stable/bin

echo '' >>$HOME/.zshrc
echo 'export PATH='"$pub_cache_bin"':$PATH' >>$HOME/.zshrc
echo 'export PATH='"$stable_bin"':$PATH' >>$HOME/.zshrc

source $HOME/.zshrc

dart pub global activate fvm
dart pub global activate flutter_gen
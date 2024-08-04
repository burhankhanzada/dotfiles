#!/usr/bin/env bash

fvm global stable

pub_cache_bin=$HOME/.pub-cache/bin
default_bin=$HOME/fvm/default/bin

echo '' >>$HOME/.zshrc
echo 'export PATH='"$pub_cache_bin"':$PATH' >>$HOME/.zshrc
echo 'export PATH='"$default_bin"':$PATH' >>$HOME/.zshrc
# echo '
# if [[ -f ~/.dvm/scripts/dvm ]]; then
#   . ~/.dvm/scripts/dvm
# fi
# ':$PATH' >>$HOME/.zshrc

source $HOME/.zshrc

dart pub global activate fvm
dart pub global activate flutter_gen
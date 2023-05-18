#!/usr/bin/env bash

sdk="$HOME/fvm/default/bin"
pub_cache="$HOME/.pub-cache/bin"

echo "path+=$sdk" >>~/.zshrc
echo "path+=$pub_cache" >>~/.zshrc
echo "export PATH" >>~/.zshrc
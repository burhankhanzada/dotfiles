#!/usr/bin/env zsh
# Flutter & FVM version manager environment configuration.

pub_cache_bin="$HOME/.pub-cache/bin"
default_fvm_bin="$HOME/fvm/default/bin"

[ -d "$pub_cache_bin" ] && export PATH="$pub_cache_bin:$PATH"
[ -d "$default_fvm_bin" ] && export PATH="$default_fvm_bin:$PATH"

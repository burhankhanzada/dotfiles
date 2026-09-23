#!/usr/bin/env zsh
# Flutter & FVM version manager environment configuration.

pub_cache_bin="$HOME/.pub-cache/bin"
default_fvm_bin="$HOME/fvm/default/bin"

[ -d "$pub_cache_bin" ] && export PATH="$pub_cache_bin:$PATH"
[ -d "$default_fvm_bin" ] && export PATH="$default_fvm_bin:$PATH"

# Auto-detect FLUTTER_ROOT and DART_ROOT
flutter_dev="${DEVELOPMENT:-$HOME/Development}/Google/Flutter"
if [ -d "$HOME/fvm/default" ]; then
    export FLUTTER_ROOT="$HOME/fvm/default"
elif [ -d "$flutter_dev/fvm/versions/stable" ]; then
    export FLUTTER_ROOT="$flutter_dev/fvm/versions/stable"
elif [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/Caskroom/flutter" ]; then
    latest_flutter=$(echo "$HOMEBREW_PREFIX"/Caskroom/flutter/*/flutter | awk '{print $NF}')
    [ -d "$latest_flutter" ] && export FLUTTER_ROOT="$latest_flutter"
fi

if [ -n "$FLUTTER_ROOT" ] && [ -d "$FLUTTER_ROOT/bin/cache/dart-sdk" ]; then
    export DART_ROOT="$FLUTTER_ROOT/bin/cache/dart-sdk"
fi

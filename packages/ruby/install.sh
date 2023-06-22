#!/usr/bin/env bash

sudo xcode-select -r

continueAbortCommand "brew install ruby-install"
continueAbortCommand "brew install chruby"

version="3.1.3"

ruby-install ruby $version

echo "source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh" >>$HOME/.zshrc
echo "source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh" >>$HOME/.zshrc
echo "chruby ruby-$version" >>$HOME/.zshrc

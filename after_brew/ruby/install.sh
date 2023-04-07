#!/usr/bin/env bash

# https://github.com/postmodern/ruby-install
# https://github.com/postmodern/chruby

sudo xcode-select -r

brew install ruby-install
brew install chruby

RUBY_VERSION=3.1.3

ruby-install ruby $RUBY_VERSION

echo "source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh" >>~/.zshrc
echo "source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh" >>~/.zshrc
echo "chruby ruby-$RUBY_VERSION" >>~/.zshrc

export RUBY_PATH="$DEVELOPMENT/Ruby"

#!/usr/bin/env bash

echo ""
echo "Installing ruby"

export RUBY_VERSION=3.1.3

ruby-install $RUBY_VERSION

chruby ruby-$RUBY_VERSION

gem install cocoapods

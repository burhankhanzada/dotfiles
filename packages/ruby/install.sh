#!/usr/bin/env bash

sudo xcode-select -r

continueAbortCommand "brew install ruby-install"
continueAbortCommand "brew install chruby"

export RUBY_VERSION="3.4.2"

ruby-install ruby $RUBY_VERSION

chruby ruby-$RUBY_VERSION
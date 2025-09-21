#!/usr/bin/env bash

echo "" >>$HOME/.zshrc
echo "export PATH=$HOME/.gem/bin:$PATH" >>$HOME/.zshrc
echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh' >>$HOME/.zshrc
echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh' >>$HOME/.zshrc
echo "chruby ruby-$RUBY_VERSION" >>$HOME/.zshrc
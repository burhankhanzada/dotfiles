#!/usr/bin/env bash

echo "" >>$HOME/.zshrc
echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh' >>$HOME/.zshrc
echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh' >>$HOME/.zshrc
echo "chruby ruby-$RUBY_VERSION" >>$HOME/.zshrc

ruby=$DEVELOPMENT/Ruby

symlink $ruby/src $HOME/src
symlink $ruby/.gem $HOME/.gem
symlink $ruby/.rubies $HOME/.rubies
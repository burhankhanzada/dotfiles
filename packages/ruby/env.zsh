#!/usr/bin/env zsh
# Ruby and chruby environment configuration.

[ -d "$HOME/.gem/bin" ] && export PATH="$HOME/.gem/bin:$PATH"

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

if [ -f "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh" ]; then
    source "$BREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
    [ -f "$BREW_PREFIX/opt/chruby/share/chruby/auto.sh" ] && source "$BREW_PREFIX/opt/chruby/share/chruby/auto.sh"
    [ -n "$RUBY_VERSION" ] && chruby "ruby-$RUBY_VERSION" 2>/dev/null || true
fi

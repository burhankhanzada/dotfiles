#!/usr/bin/env bash

if ! grep -qs "chruby.sh" "$HOME/.zshrc" 2>/dev/null; then
    echo "" >> "$HOME/.zshrc"
    echo "# Ruby / chruby start" >> "$HOME/.zshrc"
    echo "export PATH=\$HOME/.gem/bin:\$PATH" >> "$HOME/.zshrc"
    echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh' >> "$HOME/.zshrc"
    echo 'source $HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh' >> "$HOME/.zshrc"
    echo "chruby ruby-$RUBY_VERSION" >> "$HOME/.zshrc"
    echo "# Ruby / chruby end" >> "$HOME/.zshrc"
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"
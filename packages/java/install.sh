#!/usr/bin/env bash

version=11
# version=17

jdk_version="openjdk@$version"

brew install $jdk_version

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
jdk_path="$BREW_PREFIX/opt/$jdk_version"

sudo ln -sfn "$jdk_path/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-$version.jdk"

if ! grep -qs "JAVA_HOME" "$HOME/.zshenv" 2>/dev/null; then
    echo "export JAVA_HOME=\$(/usr/libexec/java_home -v $version 2>/dev/null || echo $jdk_path)" >> "$HOME/.zshenv"
fi

jdk_bin="$jdk_path/bin"

if ! grep -qs "# Java start" "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# Java start' >> "$HOME/.zshrc"
    echo "export PATH=\"$jdk_bin:\$PATH\"" >> "$HOME/.zshrc"
    echo '# Java end' >> "$HOME/.zshrc"
fi

[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

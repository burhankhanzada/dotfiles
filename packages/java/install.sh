#!/usr/bin/env bash
# Java / OpenJDK installation.

version=11
jdk_version="openjdk@$version"

brew install "$jdk_version"

BREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"
jdk_path="$BREW_PREFIX/opt/$jdk_version"

if [ -d "$jdk_path/libexec/openjdk.jdk" ]; then
    sudo ln -sfn "$jdk_path/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-$version.jdk" 2>/dev/null || true
fi

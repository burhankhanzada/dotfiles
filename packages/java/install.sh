#!/usr/bin/env bash

export JDK_VERSION="openjdk@11"

brew install $JDK_VERSION

# echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >>~/.zshenv
# echo 'export CPPFLAGS="-I/opt/homebrew/opt/$JDK_VERSION/include"' >>~/.zshenv

# path+=('/opt/homebrew/opt/$JDK_VERSION/bin')
# export PATH

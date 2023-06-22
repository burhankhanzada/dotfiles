#!/usr/bin/env bash

version=11
# version=17

jdk_version="openjdk@$version"

brew install $jdk_version

jdk_path=/opt/homebrew/opt/$jdk_version

sudo ln -sfn $jdk_path/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-$version.jdk

# echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >>~/.zshenv
echo 'export CPPFLAGS="-I/$jdk_path/include"' >>~/.zshenv

jdk_bin=$jdk_path/bin

echo '' >>$HOME/.zshrc
echo 'export PATH='"$jdk_bin"':$PATH' >>$HOME/.zshrc

source $HOME/.zshrc
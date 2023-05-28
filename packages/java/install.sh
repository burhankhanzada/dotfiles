#!/usr/bin/env bash

export JDK_VERSION="openjdk@11"

brew install $JDK_VERSION

jdk_path=/opt/homebrew/opt/$JDK_VERSION

sudo ln -sfn $jdk_path/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk

# echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >>~/.zshenv
echo 'export CPPFLAGS="-I/$jdk_path/include"' >>~/.zshenv

jdk_bin=$jdk_path/bin
echo "path+=$jdk_bin" >>$HOME/.zshrc
echo "export PATH" >>$HOME/.zshrc

source $HOME/.zshrc
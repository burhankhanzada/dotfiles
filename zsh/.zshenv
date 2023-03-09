# Enviroment Varaibles
export DOTFILES="$HOME/.dotfiles"

export PROJECTS="$HOME/Projects"
export DEVELOPMENT="$HOME/Development"

export EDITOR="code"

export PYENV_ROOT="$HOME/.pyenv"

# python=$DEVELOPMENT/Python
# export PYENV_ROOT=$PYTHON/.pyenv
# export NLTK_DATA=$PYTHON/nltk

export NODE_PATH=$DEVELOPMENT/node/node_modules

# export JAVA_HOME=$(/usr/libexec/java_home)
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"

export FVM_HOME="$flutter/fvm"

export GRADLE_USER_HOME="$DEVELOPMENT/.gradle"

google="$DEVELOPMENT/Google"
android="$google/Android/"

export ANDROID_HOME="$android/sdk"
export ANDROID_USER_HOME="$android/.android"
export ANDROID_PREFS_ROOT="$android/android"

export VSCODE_EXTENSIONS="$DEVELOPMENT/VSCode/.vscode/extensions"

export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS16.2.sdk"

# PATHS
java_paths="/opt/homebrew/opt/openjdk@11/bin"

# pyhton_paths=$PYENV_ROOT:$NLTK_DATA

flutter="$google/Flutter"
pub_cache="$flutter/.pub-cache"
flutter_paths="$flutter/sdk/bin:$pub_cache/bin"

android_paths=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/bin

export PATH=$java_paths:$pyhton_paths:$flutter_paths:$android_paths

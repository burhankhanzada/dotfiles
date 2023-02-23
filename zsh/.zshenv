# Enviroment Varaibles
export DOTFILES=$HOME/.dotfiles

export PROJECTS=~/Projects
export DEVELOPMENT=~/Development

export EDITOR='code'

# export PYTHON="$DEVELOPMENT/python"
# export NLTK_DATA="$PYTHONPATH/nltk"

export NODE_PATH="$DEVELOPMENT/node/node_modules"

export JAVA_HOME=$(/usr/libexec/java_home)
export GRADLE_USER_HOME="$DEVELOPMENT/Google/Gradle/.gradle"

# export ANDROID_PREFS_ROOT="$DEVELOPMENT/google/android"
export ANDROID_HOME="$DEVELOPMENT/Google/Android/sdk"
export ANDROID_USER_HOME="$DEVELOPMENT/Google/Android/.android"

export VSCODE_EXTENSIONS="$DEVELOPMENT/Microsoft/.vscode/extensions"

export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS16.2.sdk

# PATHS
JAVA_PATHS="$JAVA_HOME/bin"

# PYTHON_PATHS="$PYTHON:$PYTHON/scripts"

FLUTTER="$DEVELOPMENT/Google/Flutter"
PUB_CACHE="$FLUTTER/.pub-cache"
FLUTTER_PATHS="$FLUTTER/sdk/bin:$PUB_CACHE/bin"

ANDROID_PATHS="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/bin"

export PATH="$HOMEBREW_PATHS:$JAVA_PATHS:$PYTHON_PATHS:$FLUTTER_PATHS:$ANDROID_PATHS"

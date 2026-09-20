#!/usr/bin/env zsh
# Android Studio bundled JBR (Java Runtime) environment configuration.

jbr_bin="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin"
if [ -d "$jbr_bin" ]; then
    export PATH="$jbr_bin:$PATH"
fi

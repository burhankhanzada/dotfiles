#!/usr/bin/env zsh
# Java / OpenJDK environment configuration.

if [ -z "$JAVA_HOME" ]; then
    if [ -x "/usr/libexec/java_home" ]; then
        export JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"
    fi
fi

if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME/bin" ]; then
    export PATH="$JAVA_HOME/bin:$PATH"

    # Sync JAVA_HOME for macOS GUI applications (Android Studio, IDE Gradle daemons)
    if command -v launchctl &>/dev/null; then
        launchctl setenv JAVA_HOME "$JAVA_HOME" 2>/dev/null || true
    fi
fi

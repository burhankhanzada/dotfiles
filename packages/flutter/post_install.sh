#!/usr/bin/env bash
# Flutter post-installation hook.

if command -v fvm &>/dev/null; then
    fvm global stable 2>/dev/null || true
fi

if command -v dart &>/dev/null; then
    dart pub global activate fvm 2>/dev/null || true
    dart pub global activate flutter_gen 2>/dev/null || true
fi

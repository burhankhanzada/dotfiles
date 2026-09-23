#!/usr/bin/env bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

[ -d "$HOME/Development/Homebrew" ] && rmdir "$HOME/Development/Homebrew" 2>/dev/null || true
[ -d "/opt/homebrew" ] && rmdir "/opt/homebrew" 2>/dev/null || true

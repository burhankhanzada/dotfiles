#!/usr/bin/env bash
# Compatibility alias shim: loads aliases.zsh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/aliases.zsh" ] && source "$SCRIPT_DIR/aliases.zsh"

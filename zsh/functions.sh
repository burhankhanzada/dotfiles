#!/usr/bin/env bash
# Source core library so utilities are accessible from subshells and interactive shells.

export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if [ -f "$DOTFILES/core/init.sh" ]; then
    source "$DOTFILES/core/init.sh"
fi

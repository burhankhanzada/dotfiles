#!/usr/bin/env bash

# Resolve dotfiles path if run standalone
export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export MAC_OS_PATH="$DOTFILES/mac_os"

# Load helper functions if available
[ -f "$DOTFILES/functions/continue_abort.sh" ] && source "$DOTFILES/functions/continue_abort.sh"

# Prompt to apply macOS defaults
if command -v continueAbortSourceFile &>/dev/null; then
    continueAbortSourceFile 'Apply macOS Defaults?' "$MAC_OS_PATH/set_defaults.sh"
else
    source "$MAC_OS_PATH/set_defaults.sh"
fi

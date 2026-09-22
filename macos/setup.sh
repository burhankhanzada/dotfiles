#!/usr/bin/env bash
# macOS defaults setup runner.

export DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export MACOS_PATH="$DOTFILES/macos"

# Load core helpers
[ -f "$DOTFILES/core/init.sh" ] && source "$DOTFILES/core/init.sh"

# Close System Settings to avoid overrides
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# If specific category arguments are passed, run matching scripts
if [ $# -gt 0 ]; then
    for arg in "$@"; do
        script="$MACOS_PATH/defaults/${arg}.sh"
        if [ -f "$script" ]; then
            echo.Blue "Applying macOS defaults category: $arg"
            source "$script"
        fi
    done
    exit 0
fi

# Otherwise, iterate through all defaults files
for file in "$MACOS_PATH/defaults/"*.sh; do
    [ -f "$file" ] || continue
    file_name=$(basename "$file")
    if command -v continueAbortSourceFile &>/dev/null; then
        continueAbortSourceFile "Run $file_name?" "$file"
    else
        source "$file"
    fi
done

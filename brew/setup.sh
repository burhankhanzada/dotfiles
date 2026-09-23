#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

# 1. Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    echo.Blue "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo.Green "Homebrew is already installed"
fi

# 2. Detect Homebrew binary prefix
if [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
elif [ -x "/usr/local/bin/brew" ]; then
    BREW_BIN="/usr/local/bin/brew"
elif command -v brew &>/dev/null; then
    BREW_BIN="$(command -v brew)"
fi

# 3. Load brew shellenv in current shell
if [ -n "$BREW_BIN" ]; then
    eval "$($BREW_BIN shellenv)"

    # Add to ~/.zprofile only if not already present
    if ! grep -qs "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
        echo.Blue "Adding Homebrew to ~/.zprofile..."
        (
            echo
            echo "eval \"\$($BREW_BIN shellenv)\""
        ) >> "$HOME/.zprofile"
    fi
fi

# 4. Configure optional symlinks if Development/Homebrew exists
if [ -d "$DEVELOPMENT/Homebrew" ]; then
    echo.Blue "Linking Homebrew custom directories..."
    command -v symlink &>/dev/null && symlink "$DEVELOPMENT/Homebrew/Caches/Homebrew" "$HOME/Library/Caches/Homebrew"
fi

# 5. Trust taps if Homebrew tap trust is supported
if [ -f "$DOTFILES/Brewfile" ] && brew trust --help &>/dev/null; then
    while IFS= read -r tap_name; do
        [ -n "$tap_name" ] && brew trust "$tap_name" 2>/dev/null || true
    done < <(grep -E '^\s*tap\s+"' "$DOTFILES/Brewfile" | sed -E 's/^\s*tap\s+"([^"]+)".*/\1/')
fi

# 6. Install declared packages from Brewfile
if [ -f "$DOTFILES/Brewfile" ]; then
    if [ $# -gt 0 ]; then
        echo.Blue "Generating filtered Brewfile for $# selected package(s)..."
        filtered_brewfile=$(mktemp)
        python3 "$DOTFILES/core/wizard/filter_brew.py" --brewfile "$DOTFILES/Brewfile" --output "$filtered_brewfile" "$@"
        if [ -s "$filtered_brewfile" ]; then
            brew bundle --file="$filtered_brewfile"
        else
            echo.Yellow "No matching packages found in Brewfile."
        fi
        rm -f "$filtered_brewfile" 2>/dev/null
    else
        echo.Blue "Installing all packages from $DOTFILES/Brewfile..."
        brew bundle --file="$DOTFILES/Brewfile"
    fi
fi
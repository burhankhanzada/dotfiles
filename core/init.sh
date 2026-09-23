#!/usr/bin/env bash
# Core library initialization: loads all foundation utilities.

# Resolve root DOTFILES directory portably across Bash and Zsh
if [ -z "$DOTFILES" ]; then
    if [ -n "$BASH_SOURCE" ]; then
        _CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
    elif [ -n "$ZSH_VERSION" ]; then
        _CORE_DIR="$(cd "$(dirname "${(%):-%x}")" 2>/dev/null && pwd)"
    else
        _CORE_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
    fi
    export DOTFILES="$(cd "$_CORE_DIR/.." 2>/dev/null && pwd)"
fi

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export CORE_DIR="$DOTFILES/core"
export PACKAGES_PATH="${PACKAGES_PATH:-$DOTFILES/packages}"
export DEVELOPMENT="${DEVELOPMENT:-$HOME/Development}"

# Reusable Homebrew environment initialization
ensure_homebrew_env() {
    if ! command -v brew &>/dev/null; then
        if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}
ensure_homebrew_env

[ -f "$CORE_DIR/colors.sh" ] && source "$CORE_DIR/colors.sh"
[ -f "$CORE_DIR/fs.sh" ] && source "$CORE_DIR/fs.sh"
[ -f "$CORE_DIR/prompt.sh" ] && source "$CORE_DIR/prompt.sh"
[ -f "$CORE_DIR/github.sh" ] && source "$CORE_DIR/github.sh"
[ -f "$CORE_DIR/package.sh" ] && source "$CORE_DIR/package.sh"
[ -f "$CORE_DIR/tui.sh" ] && source "$CORE_DIR/tui.sh"
[ -f "$CORE_DIR/defaults.sh" ] && source "$CORE_DIR/defaults.sh"

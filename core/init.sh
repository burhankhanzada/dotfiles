#!/usr/bin/env bash
# Core library initialization: loads all foundation utilities.

CORE_DIR="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/core"

[ -f "$CORE_DIR/colors.sh" ] && source "$CORE_DIR/colors.sh"
[ -f "$CORE_DIR/fs.sh" ] && source "$CORE_DIR/fs.sh"
[ -f "$CORE_DIR/prompt.sh" ] && source "$CORE_DIR/prompt.sh"
[ -f "$CORE_DIR/github.sh" ] && source "$CORE_DIR/github.sh"
[ -f "$CORE_DIR/package.sh" ] && source "$CORE_DIR/package.sh"
[ -f "$CORE_DIR/tui.sh" ] && source "$CORE_DIR/tui.sh"
[ -f "$CORE_DIR/defaults.sh" ] && source "$CORE_DIR/defaults.sh"

#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

link_shared_ide_extensions "Antigravity IDE" "$HOME/.antigravity-ide/extensions"

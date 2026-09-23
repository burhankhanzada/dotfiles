#!/usr/bin/env zsh
# Dynamic Zsh Dotfiles Loader
# Automatically discovers and sources modular configurations from packages.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# 1. Load core library
[ -f "$DOTFILES/core/init.sh" ] && source "$DOTFILES/core/init.sh"

# 2. Load global shell environment variables
[ -f "$DOTFILES/zsh/env.zsh" ] && source "$DOTFILES/zsh/env.zsh"

# 3. Load global shell aliases
[ -f "$DOTFILES/zsh/aliases.zsh" ] && source "$DOTFILES/zsh/aliases.zsh"

# 4. Initialize native Zsh completion system (cached for fast startup)
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz compinit
    if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
fi

# 5. Dynamically load modular package configs (single filesystem pass for speed)
if [ -d "$DOTFILES/packages" ]; then
    for pkg_dir in "$DOTFILES"/packages/*; do
        [ -d "$pkg_dir" ] || continue
        [ -f "$pkg_dir/env.zsh" ] && source "$pkg_dir/env.zsh"
        [ -f "$pkg_dir/aliases.zsh" ] && source "$pkg_dir/aliases.zsh"
        [ -f "$pkg_dir/functions.zsh" ] && source "$pkg_dir/functions.zsh"
    done
fi

# 6. Native Zsh package autocompletion
if [ -n "$ZSH_VERSION" ]; then
    _dotfiles_package_completion() {
        local -a pkgs
        if [ -d "$DOTFILES/packages" ]; then
            pkgs=("$DOTFILES"/packages/*(N/:t))
            _describe 'dotfiles package' pkgs
        fi
    }
    if (( $+functions[compdef] )); then
        compdef _dotfiles_package_completion installPackage
        compdef _dotfiles_package_completion updatePackage
    fi
fi

# 7. Propagate complete developer PATH to macOS GUI apps (Antigravity IDE, VS Code, Studio)
if command -v launchctl &>/dev/null; then
    launchctl setenv PATH "$PATH" 2>/dev/null || true
fi

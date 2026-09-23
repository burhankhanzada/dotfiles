#!/usr/bin/env zsh
# Core environment variables.

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PROJECTS="${PROJECTS:-$HOME/Projects}"
export DEVELOPMENT="${DEVELOPMENT:-$HOME/Development}"
export SECRETS="${SECRETS:-$DEVELOPMENT/Secrets}"

# Keep PATH, FPATH, and MANPATH arrays unique (prevent duplicate entries)
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH 2>/dev/null || true

# Ensure Homebrew bin is in PATH early if installed
if [ -x "/opt/homebrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
    export HOMEBREW_PREFIX="/usr/local"
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------
# Zsh History Configuration
# ----------------------------------------------------------------------
export HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
export HISTSIZE=50000
export SAVEHIST=50000

if [ -n "$ZSH_VERSION" ]; then
    setopt EXTENDED_HISTORY          # Record timestamp and execution duration
    setopt SHARE_HISTORY             # Share command history across open terminal sessions
    setopt HIST_IGNORE_ALL_DUPS      # Remove older duplicate entries from history
    setopt HIST_IGNORE_SPACE         # Do not record lines starting with a space (hides secrets)
    setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from history entries
    setopt HIST_VERIFY               # Don't execute immediately upon history expansion

    # ----------------------------------------------------------------------
    # Directory Navigation Ergonomics
    # ----------------------------------------------------------------------
    setopt AUTO_CD                   # Type directory name directly to cd into it
    setopt AUTO_PUSHD                # Automatically push visited directories onto the stack
    setopt PUSHD_IGNORE_DUPS         # Do not record duplicate entries on the directory stack
    setopt PUSHD_SILENT              # Do not print directory stack after pushd/popd
fi

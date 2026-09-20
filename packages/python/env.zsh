#!/usr/bin/env zsh
# Python and Pyenv environment configuration.

export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"

if [ -d "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
fi

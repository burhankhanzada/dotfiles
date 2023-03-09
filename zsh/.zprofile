eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

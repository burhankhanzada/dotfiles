#!/usr/bin/env bash
# Idempotent ZSH setup and legacy dotfiles migration.

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

echo.Blue "==> Running ZSH setup"

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# 1. Setup .zshenv (environment variables)
if [ ! -f "$HOME/.zshenv" ]; then
    echo.Blue "Creating $HOME/.zshenv from $DOTFILES/zsh/.zshenv"
    cp "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
else
    # Ensure DOTFILES variable is declared
    if ! grep -qs "DOTFILES=" "$HOME/.zshenv" 2>/dev/null; then
        echo "export DOTFILES=\$HOME/.dotfiles" >> "$HOME/.zshenv"
    fi
    if ! grep -qs "DEVELOPMENT=" "$HOME/.zshenv" 2>/dev/null; then
        echo "export DEVELOPMENT=\$HOME/Development" >> "$HOME/.zshenv"
    fi
    if ! grep -qs "PROJECTS=" "$HOME/.zshenv" 2>/dev/null; then
        echo "export PROJECTS=\$HOME/Projects" >> "$HOME/.zshenv"
    fi
fi

# 2. Setup .zprofile (login shell profile)
if [ ! -f "$HOME/.zprofile" ]; then
    echo.Blue "Creating $HOME/.zprofile from $DOTFILES/zsh/.zprofile"
    cp "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"
fi

# 3. Setup .zshrc with dynamic init loader
if [ ! -f "$HOME/.zshrc" ]; then
    echo.Blue "Creating $HOME/.zshrc from $DOTFILES/zsh/.zshrc"
    cp "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
elif ! grep -qs "init.zsh" "$HOME/.zshrc" 2>/dev/null; then
    echo.Blue "Adding dotfiles loader to $HOME/.zshrc"
    (
        echo
        echo '# Dotfiles core loader'
        echo 'export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"'
        echo '[ -f "$DOTFILES/zsh/init.zsh" ] && source "$DOTFILES/zsh/init.zsh"'
    ) >> "$HOME/.zshrc"
fi

echo.Green "==> ZSH setup completed cleanly."

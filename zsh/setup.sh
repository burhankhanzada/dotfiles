#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

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

# 3. Setup .zshrc (non-destructive idempotent core block)
if [ ! -f "$HOME/.zshrc" ]; then
    echo.Blue "Creating $HOME/.zshrc from $DOTFILES/zsh/.zshrc"
    cp "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
else
    if ! grep -qs "# Dotfiles core start" "$HOME/.zshrc" 2>/dev/null; then
        # Create a temporary file with the core dotfiles block at the top
        temp_zshrc=$(mktemp)
        cat << 'EOF' > "$temp_zshrc"
# Dotfiles core start
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
[ -f "$DOTFILES/zsh/aliases.sh" ] && source "$DOTFILES/zsh/aliases.sh"
[ -f "$DOTFILES/zsh/functions.sh" ] && source "$DOTFILES/zsh/functions.sh"
# Dotfiles core end

EOF
        cat "$HOME/.zshrc" >> "$temp_zshrc"
        mv "$temp_zshrc" "$HOME/.zshrc"
        echo.Green "==> Injected core dotfiles block into existing $HOME/.zshrc"
    else
        echo.Green "==> Core dotfiles block already present in $HOME/.zshrc"
    fi
fi

echo.Green "==> ZSH setup completed non-destructively."

#!/usr/bin/env bash
# Idempotent ZSH setup and legacy dotfiles migration.

# Resolve colors if not loaded
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

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

# 3. Setup .zshrc with dynamic init loader and clean legacy pollution
if [ ! -f "$HOME/.zshrc" ]; then
    echo.Blue "Creating $HOME/.zshrc from $DOTFILES/zsh/.zshrc"
    cp "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
else
    # Scrub legacy hardcoded package blocks if present
    legacy_patterns=(
        "/# Android Tools start/,/# Android Tools end/d"
        "/# Android start/,/# Android end/d"
        "/# Android Studio start/,/# Android Studio end/d"
        "/# Cmake start/,/# Cmake end/d"
        "/# LLVM start/,/# LLVM end/d"
        "/# Flutter start/,/# Flutter end/d"
        "/# Java start/,/# Java end/d"
        "/# Ruby \/ chruby start/,/# Ruby \/ chruby end/d"
        "/# Antigravity IDE start/,/# Antigravity IDE end/d"
        "/# Dotfiles core start/,/# Dotfiles core end/d"
    )

    for pattern in "${legacy_patterns[@]}"; do
        if [ -f "$HOME/.zshrc" ]; then
            sed -i '' "$pattern" "$HOME/.zshrc" 2>/dev/null || true
        fi
    done

    # Inject the clean unified loader at the top
    temp_zshrc=$(mktemp)
    cat << 'EOF' > "$temp_zshrc"
# Dotfiles core start
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
[ -f "$DOTFILES/zsh/init.zsh" ] && source "$DOTFILES/zsh/init.zsh"
# Dotfiles core end

EOF
    cat "$HOME/.zshrc" >> "$temp_zshrc"
    mv "$temp_zshrc" "$HOME/.zshrc"
    echo.Green "==> Injected clean dynamic dotfiles loader into $HOME/.zshrc"
fi

echo.Green "==> ZSH setup completed cleanly."

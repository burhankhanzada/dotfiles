#!/usr/bin/env zsh

# Dotfiles management
alias dotfiles='cd "$DOTFILES"'
alias doctor='make -C "$DOTFILES" doctor'
alias dotstatus='make -C "$DOTFILES" status'
alias dotcheck='make -C "$DOTFILES" check'

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias proj='cd "$PROJECTS"'
alias devl='cd "$DEVELOPMENT"'

# Terminal & Shell productivity
alias cls="clear"
alias reld="source \$HOME/.zshrc"
alias path='echo $PATH | tr ":" "\n"'

# Enhanced ls with eza / exa
if command -v eza &>/dev/null; then
    alias ls="eza --icons --group-directories-first"
    alias l="eza -1 --icons --group-directories-first"
    alias ll="eza -l --icons --git --group-directories-first"
    alias la="eza -la --icons --git --group-directories-first"
    alias lt="eza --tree --level=2 --icons"
elif command -v exa &>/dev/null; then
    alias ls="exa --icons --group-directories-first"
    alias l="exa -1 --icons --group-directories-first"
    alias ll="exa -l --icons --git --group-directories-first"
    alias la="exa -la --icons --git --group-directories-first"
    alias lt="exa --tree --level=2 --icons"
fi

# Git shortcuts
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline -n 15"
alias gp="git push"
alias gpl="git pull"

# Safe file operations (prompt before overwrite/delete)
alias cp="cp -i"
alias mv="mv -i"
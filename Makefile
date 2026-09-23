.PHONY: help install update check dry-run packages list status defaults reset-macos zsh doctor

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Dotfiles Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Run the interactive dotfiles installer wizard
	@./bootstrap.sh

update: ## Pull dotfiles, update Homebrew packages, and update package toolchains
	@echo "==> Updating dotfiles repository..."
	@git pull --ff-only 2>/dev/null || echo "Git pull skipped (diverged or uncommitted changes)"
	@if command -v brew &>/dev/null; then echo "==> Updating Homebrew..."; brew update; fi
	@echo "==> Updating modular packages..."
	@./packages/setup.sh --update $(PKG)

dry-run: ## Preview dotfiles installation without modifying the system
	@./bootstrap.sh --dry-run

check: ## Verify syntax of all shell scripts and compile all Python modules
	@echo "==> Checking Bash shell scripts syntax (bash -n)..."
	@bash -n bootstrap.sh brew/setup.sh macos/setup.sh macos/reset.sh packages/setup.sh zsh/setup.sh core/*.sh macos/defaults/*.sh packages/*/*.sh
	@echo "==> Checking Zsh shell scripts syntax (zsh -n)..."
	@zsh -n zsh/*.zsh packages/*/*.zsh
	@echo "==> Compiling Python modules (py_compile)..."
	@python3 -m py_compile core/wizard/*.py core/tui_wizard.py
	@echo "\033[32m✔ All checks passed successfully!\033[0m"

packages: ## Run the packages & tools installer (e.g. make packages PKG="git node")
	@./packages/setup.sh $(PKG)

list: ## List all available modular packages
	@./packages/setup.sh --list

status: ## Check tool presence and config status across all packages
	@./packages/setup.sh --status

defaults: ## Run the macOS system defaults configuration
	@./macos/setup.sh

reset-macos: ## Reset macOS system preferences to default values
	@./macos/setup.sh --reset

zsh: ## Run the ZSH environment and alias setup
	@./zsh/setup.sh

doctor: ## Diagnose developer tool health, SDK paths, and GUI environment sync
	@./core/doctor.sh

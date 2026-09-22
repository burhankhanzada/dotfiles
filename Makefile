.PHONY: help install check dry-run packages list defaults zsh

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Dotfiles Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Run the interactive dotfiles installer wizard
	@./bootstrap.sh

dry-run: ## Preview dotfiles installation without modifying the system
	@./bootstrap.sh --dry-run

check: ## Verify syntax of all shell scripts and compile all Python modules
	@echo "==> Checking shell scripts syntax (bash -n)..."
	@bash -n bootstrap.sh brew/setup.sh macos/setup.sh packages/setup.sh zsh/setup.sh core/*.sh macos/defaults/*.sh
	@echo "==> Compiling Python modules (py_compile)..."
	@python3 -m py_compile core/wizard/*.py core/tui_wizard.py
	@echo "\033[32m✔ All checks passed successfully!\033[0m"

packages: ## Run the packages & tools installer
	@./packages/setup.sh

list: ## List all available modular packages
	@./packages/setup.sh --list

defaults: ## Run the macOS system defaults configuration
	@./macos/setup.sh

zsh: ## Run the ZSH environment and alias setup
	@./zsh/setup.sh

#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

# Discover package directories dynamically from filesystem
discover_available_packages() {
    find "$DOTFILES/packages" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v '^\.' | sort
}

# Parse command line flags
AUTO_ALL="${AUTO_ALL:-false}"
USE_TUI=true

for arg in "$@"; do
    case "$arg" in
        -y|--yes|--all)
            AUTO_ALL=true
            USE_TUI=false
            export AUTO_ALL=true
            ;;
        --no-tui)
            USE_TUI=false
            ;;
        -l|--list)
            echo.Blue "Available packages with custom configs:"
            for pkg in $(discover_available_packages); do
                echo "  - $pkg"
            done
            exit 0
            ;;
        -h|--help)
            echo "Usage: ./setup.sh [OPTIONS]"
            echo
            echo "Options:"
            echo "  -y, --yes, --all    Configure all packages non-interactively"
            echo "  --no-tui            Use sequential text prompts instead of TUI wizard"
            echo "  -l, --list          List all available packages"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
    esac
done

selected_to_install=()

# Interactive TUI Wizard selection
if command -v run_tui_wizard &>/dev/null && [ "$USE_TUI" = "true" ] && [ "$AUTO_ALL" != "true" ] && [ -t 0 ]; then
    tmp_json=$(mktemp)
    trap 'rm -f "$tmp_json" 2>/dev/null' EXIT

    if run_tui_wizard packages-only "$tmp_json"; then
        if [ -f "$tmp_json" ] && [ -s "$tmp_json" ]; then
            eval "$(python3 "$DOTFILES/core/wizard/summary.py" --env "$tmp_json")"
            selected_to_install=("${chosen_packages[@]}")
        fi
    else
        echo
        echo.Red "==> Package configuration cancelled by user."
        exit 0
    fi
    rm -f "$tmp_json" 2>/dev/null
fi

# Fallback: if TUI was not used or bypassed with --yes, populate from valid packages
if [ ${#selected_to_install[@]} -eq 0 ] && [[ "$AUTO_ALL" == "true" ]]; then
    while IFS= read -r pkg; do
        [ -n "$pkg" ] && selected_to_install+=("$pkg")
    done < <(discover_available_packages)
fi

if [ ${#selected_to_install[@]} -eq 0 ]; then
    echo
    echo.Yellow "No packages selected for configuration."
    exit 0
fi

echo
echo.Blue "═══════════════════════════════════════════════════════"
echo.Blue "  Configuring ${#selected_to_install[@]} selected package(s)...        "
echo.Blue "═══════════════════════════════════════════════════════"

start_time=$(date +%s)
configured_pkgs=()
skipped_pkgs=()
current_idx=0
total_pkgs=${#selected_to_install[@]}

for dir_name in "${selected_to_install[@]}"; do
    ((current_idx++))
    printf_idx=$(printf "%02d/%02d" "$current_idx" "$total_pkgs")

    echo
    echo.Blue "── [ $printf_idx ] ─────────────────────────────────────────"

    if [ -d "$DOTFILES/packages/$dir_name" ]; then
        echo.Green "==> Setting up: $dir_name"
        installPackage "$dir_name"
        configured_pkgs+=("$dir_name")
    else
        echo.Yellow "==> Skipping (not found): $dir_name"
        skipped_pkgs+=("$dir_name")
    fi
done

end_time=$(date +%s)
duration=$((end_time - start_time))

echo
echo.Blue "═══════════════════════════════════════════════════════"
echo.Blue "  Package Configuration Summary (${duration}s)          "
echo.Blue "═══════════════════════════════════════════════════════"
if [ ${#configured_pkgs[@]} -gt 0 ]; then
    echo.Green "✔ Configured (${#configured_pkgs[@]}):"
    for pkg in "${configured_pkgs[@]}"; do
        echo -e "   \033[0;32m✔\033[0m $pkg"
    done
fi

if [ ${#skipped_pkgs[@]} -gt 0 ]; then
    echo
    echo.Yellow "➜ Skipped (${#skipped_pkgs[@]}):"
    for pkg in "${skipped_pkgs[@]}"; do
        echo -e "   \033[0;33m➜\033[0m $pkg"
    done
fi
echo

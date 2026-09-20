#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Magenta &>/dev/null || echo.Magenta() { echo -e "\033[0;35m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

# Source core library
[ -f "$DOTFILES/core/init.sh" ] && source "$DOTFILES/core/init.sh"

# Packages with custom setup, configurations, or symlinks
packages_with_configs=(
    "git"
    "vscode"
    "antigravity-ide"
    "warp"
    "generic"
    "flutter"
    "android-tools"
    "android-studio"
    "xcode"
    "python"
    "ruby"
    "rust"
    "node"
    "java"
    "cmake"
    "cocoapods"
    "llvm"
    "parallels"
    "firebase"
    "yabai"
    "wine"
)

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
            for pkg in "${packages_with_configs[@]}"; do
                if [ -d "$DOTFILES/packages/$pkg" ]; then
                    echo "  - $pkg"
                fi
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
wizard_py="$DOTFILES/core/tui_wizard.py"

if [[ "$USE_TUI" == "true" ]] && [[ "$AUTO_ALL" != "true" ]] && [ -t 0 ] && command -v python3 &>/dev/null && [ -f "$wizard_py" ]; then
    tmp_json=$(mktemp)
    trap 'rm -f "$tmp_json" 2>/dev/null' EXIT

    if python3 "$wizard_py" --packages-only --output "$tmp_json"; then
        if [ -f "$tmp_json" ] && [ -s "$tmp_json" ]; then
            # Read selected packages array from JSON
            while IFS= read -r pkg; do
                [ -n "$pkg" ] && selected_to_install+=("$pkg")
            done < <(python3 -c "import json, sys; data=json.load(open('$tmp_json')); print('\n'.join(data.get('packages', [])))")
        fi
    else
        echo
        echo.Red "==> Package configuration cancelled by user."
        exit 0
    fi
    rm -f "$tmp_json"
fi

# Fallback: if TUI was not used or bypassed with --yes, populate from valid packages
if [ ${#selected_to_install[@]} -eq 0 ] && [[ "$AUTO_ALL" == "true" ]]; then
    for dir_name in "${packages_with_configs[@]}"; do
        [ -d "$DOTFILES/packages/$dir_name" ] && selected_to_install+=("$dir_name")
    done
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

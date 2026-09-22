#!/usr/bin/env bash

# Source core library
[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
export PACKAGES_PATH="${PACKAGES_PATH:-$DOTFILES/packages}"

# Discover package directories dynamically from filesystem
discover_available_packages() {
    find "$PACKAGES_PATH" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v '^\.' | sort
}

# Parse command line flags and positional package names
AUTO_ALL="${AUTO_ALL:-false}"
USE_TUI=true
DRY_RUN="${DRY_RUN:-false}"
SHOW_STATUS=false
specified_packages=()

show_package_status() {
    echo.Blue "════════════════════════════════════════════════════════════════════"
    echo.Blue "  Modular Packages & Tools Status                                  "
    echo.Blue "════════════════════════════════════════════════════════════════════"
    printf "  \033[1m%-18s %-14s %-20s %s\033[0m\n" "PACKAGE" "BINARY / APP" "HOOKS" "SHELL CONFIG"
    echo "  ──────────────────────────────────────────────────────────────────"

    local total=0
    local installed=0

    for pkg in $(discover_available_packages); do
        ((total++))
        local pkg_dir="$PACKAGES_PATH/$pkg"

        # Detect tool presence
        local bin_status="\033[33m• not detected\033[0m"
        case "$pkg" in
            android-studio)  [ -d "/Applications/Android Studio.app" ] && bin_status="\033[32m✔ installed\033[0m" ;;
            android-tools)   (command -v adb &>/dev/null || command -v sdkmanager &>/dev/null || command -v avdmanager &>/dev/null) && bin_status="\033[32m✔ installed\033[0m" ;;
            antigravity-ide) [ -d "/Applications/Antigravity.app" ] || [ -d "/Applications/Antigravity IDE.app" ] && bin_status="\033[32m✔ installed\033[0m" ;;
            cmake)           command -v cmake &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            cocoapods)       command -v pod &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            firebase)        command -v firebase &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            flutter)         command -v flutter &>/dev/null || command -v fvm &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            generic)         bin_status="\033[36m• system\033[0m" ;;
            git)             command -v git &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            java)            command -v java &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            llvm)            command -v clang &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            node)            command -v node &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            parallels)       [ -d "/Applications/Parallels Desktop.app" ] && bin_status="\033[32m✔ installed\033[0m" ;;
            python)          command -v python3 &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            ruby)            command -v ruby &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            rust)            command -v rustc &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            vscode)          command -v code &>/dev/null || [ -d "/Applications/Visual Studio Code.app" ] && bin_status="\033[32m✔ installed\033[0m" ;;
            warp)            [ -d "/Applications/Warp.app" ] && bin_status="\033[32m✔ installed\033[0m" ;;
            wine)            command -v wine &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            xcode)           xcode-select -p &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            yabai)           command -v yabai &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
            *)               command -v "$pkg" &>/dev/null && bin_status="\033[32m✔ installed\033[0m" ;;
        esac

        [[ "$bin_status" == *"✔"* ]] && ((installed++))

        # Detect hooks
        local hooks=()
        [ -f "$pkg_dir/install.sh" ] && hooks+=("install")
        [ -f "$pkg_dir/links.sh" ] && hooks+=("links")
        [ -f "$pkg_dir/post_install.sh" ] && hooks+=("post")
        local hooks_str="none"
        [ ${#hooks[@]} -gt 0 ] && hooks_str=$(IFS=, ; echo "${hooks[*]}")

        # Detect shell integration
        local shell_parts=()
        [ -f "$pkg_dir/env.zsh" ] && shell_parts+=("env")
        [ -f "$pkg_dir/aliases.zsh" ] && shell_parts+=("aliases")
        [ -f "$pkg_dir/functions.zsh" ] && shell_parts+=("functions")
        local shell_str="none"
        [ ${#shell_parts[@]} -gt 0 ] && shell_str=$(IFS=, ; echo "${shell_parts[*]}")

        printf "  %-18s %-24b %-20s %s\n" "$pkg" "$bin_status" "$hooks_str" "$shell_str"
    done

    echo "  ──────────────────────────────────────────────────────────────────"
    echo.Green "  Detected $installed/$total tools installed on the system."
    echo
}

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
        --dry-run)
            DRY_RUN=true
            export DRY_RUN=true
            ;;
        -s|--status)
            show_package_status
            exit 0
            ;;
        -l|--list)
            echo.Blue "Available packages with custom configs:"
            for pkg in $(discover_available_packages); do
                echo "  - $pkg"
            done
            exit 0
            ;;
        -h|--help)
            echo "Usage: ./packages/setup.sh [OPTIONS] [PACKAGE ...]"
            echo
            echo "Options:"
            echo "  -y, --yes, --all    Configure all packages non-interactively"
            echo "  --no-tui            Bypass interactive TUI wizard"
            echo "  --dry-run           Preview actions without executing hooks or symlinks"
            echo "  -s, --status        Check binary and symlink status for all packages"
            echo "  -l, --list          List all available packages"
            echo "  -h, --help          Show this help message"
            echo
            echo "Examples:"
            echo "  ./packages/setup.sh git node       Install specific packages directly"
            echo "  ./packages/setup.sh --status       Inspect tool and config status"
            echo "  ./packages/setup.sh --dry-run      Preview package configurations"
            echo "  ./packages/setup.sh --list         List all available packages"
            exit 0
            ;;
        -*)
            echo.Yellow "Warning: Unknown option '$arg'"
            ;;
        *)
            specified_packages+=("$arg")
            ;;
    esac
done

selected_to_install=()

# Direct arguments bypass wizard
if [ ${#specified_packages[@]} -gt 0 ]; then
    selected_to_install=("${specified_packages[@]}")
# Interactive TUI Wizard selection
elif command -v run_tui_wizard &>/dev/null && [ "$USE_TUI" = "true" ] && [ "$AUTO_ALL" != "true" ] && [ -t 0 ]; then
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

    if [ -d "$PACKAGES_PATH/$dir_name" ]; then
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

#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Magenta &>/dev/null || echo.Magenta() { echo -e "\033[0;35m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }

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

for arg in "$@"; do
    case "$arg" in
        -y|--yes|--all)
            AUTO_ALL=true
            export AUTO_ALL=true
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
            echo "  -l, --list          List all available packages"
            echo "  -h, --help          Show this help message"
            exit 0
            ;;
    esac
done

echo
echo.Blue "═══════════════════════════════════════════════════════"
echo.Blue "  Configuring packages with custom settings & links    "
echo.Blue "═══════════════════════════════════════════════════════"

total_pkgs=0
valid_packages=()
for dir_name in "${packages_with_configs[@]}"; do
    if [ -d "$DOTFILES/packages/$dir_name" ]; then
        valid_packages+=("$dir_name")
        ((total_pkgs++))
    fi
done

start_time=$(date +%s)
configured_pkgs=()
skipped_pkgs=()
current_idx=0

for dir_name in "${valid_packages[@]}"; do
    ((current_idx++))
    printf_idx=$(printf "%02d/%02d" "$current_idx" "$total_pkgs")

    echo
    echo.Blue "── [ $printf_idx ] ─────────────────────────────────────────"

    if [[ "$AUTO_ALL" == "true" ]]; then
        echo.Green "==> Automatically setting up: $dir_name"
        installPackage "$dir_name"
        configured_pkgs+=("$dir_name")
        continue
    fi

    echo -ne "\033[0;35m? Configure $dir_name? [Y/n/a(ll)/q(uit)]: \033[0m"
    read -r -n 1 key
    echo

    case "$key" in
        ""|[yY])
            installPackage "$dir_name"
            configured_pkgs+=("$dir_name")
            ;;
        [aA])
            AUTO_ALL=true
            export AUTO_ALL=true
            echo.Green "==> Auto-approving all remaining packages."
            installPackage "$dir_name"
            configured_pkgs+=("$dir_name")
            ;;
        [qQ])
            echo.Red "==> Setup quit by user."
            skipped_pkgs+=("$dir_name (aborted)")
            break
            ;;
        *)
            echo.Yellow "==> Skipped $dir_name."
            skipped_pkgs+=("$dir_name")
            ;;
    esac
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

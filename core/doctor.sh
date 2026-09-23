#!/usr/bin/env bash
# Dotfiles & Development Environment Doctor
# Diagnoses installed tool versions, environment variables, symlinks, and macOS GUI sync.

[ -f "${DOTFILES:-$HOME/.dotfiles}/core/init.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/init.sh"

echo
echo.Blue "════════════════════════════════════════════════════════════════════"
echo.BoldCyan "  Dotfiles Environment & Tooling Doctor 🩺                          "
echo.Blue "════════════════════════════════════════════════════════════════════"

# 1. Check Tool Executables
echo
echo.BoldWhite "▶ Developer Tool Binaries:"
tools=("git" "brew" "zsh" "python3" "node" "java" "android" "adb" "avdmanager" "sdkmanager" "dart" "flutter" "fvm")

for t in "${tools[@]}"; do
    if command -v "$t" &>/dev/null; then
        loc=$(command -v "$t")
        printf "  \033[32m✔\033[0m \033[1m%-14s\033[0m -> %s\n" "$t" "$loc"
    else
        printf "  \033[33m•\033[0m \033[1m%-14s\033[0m -> \033[90mnot found\033[0m\n" "$t"
    fi
done

# 2. Check Key Environment Variables
echo
echo.BoldWhite "▶ Shell Environment Variables (Zsh & User Environment):"

# Resolve configured shell environment if doctor is invoked in standalone subshell
if [ -z "$ANDROID_HOME" ] && command -v zsh &>/dev/null; then
    eval "$(zsh -c 'source ~/.dotfiles/zsh/init.zsh 2>/dev/null; printf "ANDROID_HOME=\"%s\" ANDROID_SDK_ROOT=\"%s\" JAVA_HOME=\"%s\" FLUTTER_ROOT=\"%s\" DART_ROOT=\"%s\"\n" "$ANDROID_HOME" "$ANDROID_SDK_ROOT" "$JAVA_HOME" "$FLUTTER_ROOT" "$DART_ROOT"' 2>/dev/null)" 2>/dev/null || true
fi

env_vars=("ANDROID_HOME" "ANDROID_SDK_ROOT" "JAVA_HOME" "FLUTTER_ROOT" "DART_ROOT" "HOMEBREW_PREFIX")

for v in "${env_vars[@]}"; do
    val="${!v}"
    if [ -n "$val" ]; then
        if [ -e "$val" ]; then
            printf "  \033[32m✔\033[0m \033[1m%-18s\033[0m = %s \033[32m(exists)\033[0m\n" "$v" "$val"
        else
            printf "  \033[33m•\033[0m \033[1m%-18s\033[0m = %s \033[31m(missing on disk)\033[0m\n" "$v" "$val"
        fi
    else
        printf "  \033[33m•\033[0m \033[1m%-18s\033[0m = \033[90m<unset in current subshell>\033[0m\n" "$v"
    fi
done

# 3. Check macOS GUI Environment (launchctl)
if command -v launchctl &>/dev/null; then
    echo
    echo.BoldWhite "▶ macOS GUI Environment (launchctl):"
    gui_vars=("PATH" "ANDROID_HOME" "ANDROID_SDK_ROOT" "JAVA_HOME" "FLUTTER_ROOT" "DART_ROOT")
    for gv in "${gui_vars[@]}"; do
        gval=$(launchctl getenv "$gv" 2>/dev/null)
        if [ -n "$gval" ]; then
            if [ ${#gval} -gt 60 ]; then
                trimmed="${gval:0:57}..."
            else
                trimmed="$gval"
            fi
            printf "  \033[32m✔\033[0m \033[1m%-18s\033[0m = %s\n" "$gv" "$trimmed"
        else
            printf "  \033[33m•\033[0m \033[1m%-18s\033[0m = \033[90m<unset in GUI session>\033[0m\n" "$gv"
        fi
    done
fi

# 4. Check Critical Symlinks
echo
echo.BoldWhite "▶ Development Symlinks & Directory Health:"
links=(
    "$HOME/Library/Android/sdk"
    "$HOME/.android"
    "$HOME/.gradle"
    "$HOME/fvm"
    "$HOME/.pub-cache"
    "$HOME/.vscode-base-ide-extensions"
)

for l in "${links[@]}"; do
    if [ -L "$l" ]; then
        target=$(readlink "$l")
        if [ -e "$l" ]; then
            echo -e "  \033[32m✔\033[0m \033[1m$l\033[0m -> $target"
        else
            echo -e "  \033[31m✖\033[0m \033[1m$l\033[0m -> $target \033[31m(broken link!)\033[0m"
        fi
    elif [ -e "$l" ]; then
        echo -e "  \033[36m•\033[0m \033[1m$l\033[0m (physical directory)"
    else
        echo -e "  \033[90m• $l (not present)\033[0m"
    fi
done

echo
echo.Blue "════════════════════════════════════════════════════════════════════"
echo.Green "  ✔ Doctor diagnostic complete."
echo

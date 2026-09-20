#!/usr/bin/env bash

# Fallback echo helpers if run standalone
command -v echo.Yellow &>/dev/null || echo.Yellow() { echo -e "\033[0;33m$*\033[0m"; }
command -v echo.Magenta &>/dev/null || echo.Magenta() { echo -e "\033[0;35m$*\033[0m"; }
command -v echo.Red &>/dev/null || echo.Red() { echo -e "\033[0;31m$*\033[0m"; }
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }
command -v echo.Blue &>/dev/null || echo.Blue() { echo -e "\033[0;34m$*\033[0m"; }

function continueAbortCommand() {
    local command="$1"

    echo
    echo.Blue "┌─ [COMMAND] ──────────────────────────────────────────"
    echo.Yellow "│ $command"
    echo.Blue "└──────────────────────────────────────────────────────"

    # Non-interactive / Auto-all bypass
    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]]; then
        echo.Green "==> Automatically executing: $command"
        eval "$command"
        return $?
    fi

    echo -ne "\033[0;35m? Run command? [Y/n/a(ll)/q(uit)]: \033[0m"
    read -r -n 1 key
    echo

    case "$key" in
        ""|[yY])
            eval "$command"
            ;;
        [aA])
            export AUTO_ALL=true
            echo.Green "==> Auto-approving all subsequent commands."
            eval "$command"
            ;;
        [qQ])
            echo.Red "==> Aborted by user."
            return 1
            ;;
        *)
            echo.Yellow "==> Skipped."
            ;;
    esac
}

function continueAbortSourceFile() {
    local title="$1"
    local file="$2"
    local arg="$3"

    echo
    echo.Blue "┌─ [SOURCE] ───────────────────────────────────────────"
    echo.Yellow "│ $title"
    echo.Blue "└──────────────────────────────────────────────────────"

    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]]; then
        echo.Green "==> Automatically sourcing: $file"
        if [ -z "${arg+set}" ]; then
            source "$file"
        else
            source "$file" "$arg"
        fi
        return $?
    fi

    echo -ne "\033[0;35m? Run file? [Y/n/a(ll)/q(uit)]: \033[0m"
    read -r -n 1 key
    echo

    case "$key" in
        ""|[yY])
            if [ -z "${arg+set}" ]; then
                source "$file"
            else
                source "$file" "$arg"
            fi
            ;;
        [aA])
            export AUTO_ALL=true
            echo.Green "==> Auto-approving all subsequent files."
            if [ -z "${arg+set}" ]; then
                source "$file"
            else
                source "$file" "$arg"
            fi
            ;;
        [qQ])
            echo.Red "==> Aborted by user."
            return 1
            ;;
        *)
            echo.Yellow "==> Skipped."
            ;;
    esac
}

#!/usr/bin/env bash
# Interactive command and source confirmation prompts.

# Resolve colors if not loaded
command -v echo.Blue &>/dev/null || [ -f "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" 2>/dev/null || true

function continueAbortCommand() {
    local command="$1"

    echo
    echo.Blue "┌─ [COMMAND] ──────────────────────────────────────────"
    echo.Yellow "│ $command"
    echo.Blue "└──────────────────────────────────────────────────────"

    # Non-interactive / Auto-all bypass
    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]] || [ ! -t 0 ]; then
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
    shift 2

    echo
    echo.Blue "┌─ [SOURCE] ───────────────────────────────────────────"
    echo.Yellow "│ $title"
    echo.Blue "└──────────────────────────────────────────────────────"

    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]] || [ ! -t 0 ]; then
        echo.Green "==> Automatically sourcing: $file"
        source "$file" "$@"
        return $?
    fi

    echo -ne "\033[0;35m? Run file? [Y/n/a(ll)/q(uit)]: \033[0m"
    read -r -n 1 key
    echo

    case "$key" in
        ""|[yY])
            source "$file" "$@"
            ;;
        [aA])
            export AUTO_ALL=true
            echo.Green "==> Auto-approving all subsequent files."
            source "$file" "$@"
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

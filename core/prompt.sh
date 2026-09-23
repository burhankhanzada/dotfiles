#!/usr/bin/env bash
# Interactive command and source confirmation prompts.

# Resolve colors if not loaded
command -v echo.Blue &>/dev/null || [ -f "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" ] && source "${DOTFILES:-$HOME/.dotfiles}/core/colors.sh" 2>/dev/null || true

_confirm_action() {
    local type="$1"
    local title="$2"
    local action="$3"
    shift 3

    echo
    echo.Blue "┌─ [$type] ──────────────────────────────────────────"
    echo.Yellow "│ $title"
    echo.Blue "└──────────────────────────────────────────────────────"

    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]] || [ ! -t 0 ]; then
        echo.Green "==> Automatically executing: $title"
        $action "$@"
        return $?
    fi

    echo -ne "\033[0;35m? Proceed? [Y/n/a(ll)/q(uit)]: \033[0m"
    read -r -n 1 key
    echo

    case "$key" in
        ""|[yY])
            $action "$@"
        ;;
        [aA])
            export AUTO_ALL=true
            echo.Green "==> Auto-approving all subsequent actions."
            $action "$@"
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

function continueAbortCommand() {
    _confirm_action "COMMAND" "$1" eval "$1"
}

function continueAbortSourceFile() {
    local title="$1"
    local file="$2"
    shift 2
    _confirm_action "SOURCE" "$title" source "$file" "$@"
}

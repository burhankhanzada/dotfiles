#!/usr/bin/env bash
# Helper function to launch the Claude Code-style TUI wizard.

function run_tui_wizard() {
    local mode="${1:-full}"
    local output_json="$2"

    local wizard_bin="$DOTFILES/core/tui_wizard.py"
    [ ! -f "$wizard_bin" ] && wizard_bin="$DOTFILES/functions/tui_wizard.py"

    if [ ! -f "$wizard_bin" ]; then
        return 1
    fi

    local flags=()
    if [ "$mode" == "packages-only" ]; then
        flags+=("--packages-only")
    fi

    if [ -n "$output_json" ]; then
        flags+=("--output" "$output_json")
    fi

    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]]; then
        flags+=("--all")
    fi

    # Ensure python3 is available
    if command -v python3 &>/dev/null; then
        python3 "$wizard_bin" "${flags[@]}"
        return $?
    fi

    return 1
}

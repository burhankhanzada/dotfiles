#!/usr/bin/env bash
# Helper function to launch the interactive TUI wizard.

function run_tui_wizard() {
    local mode="${1:-full}"
    local output_json="$2"

    local wizard_bin="${DOTFILES:-$HOME/.dotfiles}/core/tui_wizard.py"

    if [ ! -f "$wizard_bin" ] || ! command -v python3 &>/dev/null; then
        return 1
    fi

    # Check if TUI should be bypassed
    if [[ "${USE_TUI:-true}" == "false" ]] || [ ! -t 0 ]; then
        if [[ "${AUTO_ALL:-false}" != "true" ]]; then
            return 1
        fi
    fi

    local flags=()
    if [ "$mode" = "packages-only" ]; then
        flags+=("--packages-only")
    fi

    if [ -n "$output_json" ]; then
        flags+=("--output" "$output_json")
    fi

    if [[ "${AUTO_ALL:-false}" == "true" ]] || [[ "${DOTFILES_NON_INTERACTIVE:-false}" == "true" ]]; then
        flags+=("--all")
    fi

    python3 "$wizard_bin" "${flags[@]}"
    return $?
}

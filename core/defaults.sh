#!/usr/bin/env bash
# Shared runner for macOS defaults modules: dynamically discovers and runs functions by prefix.
# Supports both Bash (compgen) and Zsh (functions array).

run_defaults_functions() {
    local prefix="$1"
    shift

    if [ $# -gt 0 ]; then
        for fn in "$@"; do
            [[ "$fn" != "${prefix}_"* ]] && fn="${prefix}_$fn"
            if declare -f "$fn" >/dev/null; then
                "$fn"
            fi
        done
    else
        local funcs=()
        if [ -n "$ZSH_VERSION" ]; then
            funcs=(${(f)"$(print -l ${(ok)functions[(I)${prefix}_*]} | sort)"})
        else
            funcs=($(compgen -A function "${prefix}_" | sort))
        fi
        for fn in "${funcs[@]}"; do
            "$fn"
        done
    fi
}

#!/usr/bin/env bash
# Shared runner for macOS defaults modules: dynamically discovers and runs functions by prefix.
# Supports both Bash (compgen) and Zsh (functions array).

run_defaults_functions() {
    local prefix="$1"
    shift

    if [ $# -gt 0 ]; then
        while [ $# -gt 0 ]; do
            local arg="$1"
            shift
            local fn=""
            local val="enable"

            if [[ "$arg" == *"="* ]]; then
                fn="${arg%%=*}"
                val="${arg#*=}"
            elif [[ "$arg" == *":"* ]]; then
                fn="${arg%%:*}"
                val="${arg#*:}"
            elif [ $# -gt 0 ] && [[ "$1" =~ ^(true|false|enable|disable|0|1|on|off)$ ]]; then
                fn="$arg"
                val="$1"
                shift
            else
                fn="$arg"
                val="enable"
            fi

            [[ "$fn" != "${prefix}_"* ]] && fn="${prefix}_$fn"
            if declare -f "$fn" >/dev/null; then
                "$fn" "$val"
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
            "$fn" "enable"
        done
    fi
}

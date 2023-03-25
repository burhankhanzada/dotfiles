#!/usr/bin/env bash

function source_if_exists() {
    if test -r "$1"; then
        # shellcheck source=/dev/null
        source "$1"
    fi
}

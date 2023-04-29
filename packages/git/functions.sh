#!/usr/bin/env bash

function gg {
    git branch | grep "$1" | head -1 | xargs git checkout
}

function show_git_head() {
    pretty_git_log -1
    git show -p --pretty="tformat:"
}

function pretty_git_log() {
    git log --since="6 months ago" --graph --pretty="tformat:${LOG_FORMAT}" $* | pretty_git_format | git_page_maybe
}

function pretty_git_log_all() {
    git log --all --since="6 months ago" --graph --pretty="tformat:${LOG_FORMAT}" $* | pretty_git_format | git_page_maybe
}

function pretty_git_branch() {
    git branch -v --color=always --format=${BRANCH_FORMAT} $* | pretty_git_format
}

function pretty_git_branch_sorted() {
    git branch -v --color=always --format=${BRANCH_FORMAT} --sort=-committerdate $* | pretty_git_format
}

function pretty_git_format() {
    # Replace (2 years ago) with (2 years)
    sed -Ee 's/(^[^)]*) ago\)/\1)/' |
        # Replace (2 years, 5 months) with (2 years)
        sed -Ee 's/(^[^)]*), [[:digit:]]+ .*months?\)/\1)/' |
        # Shorten time
        sed -Ee 's/ seconds?\)/s\)/' |
        sed -Ee 's/ minutes?\)/m\)/' |
        sed -Ee 's/ hours?\)/h\)/' |
        sed -Ee 's/ days?\)/d\)/' |
        sed -Ee 's/ weeks?\)/w\)/' |
        sed -Ee 's/ months?\)/M\)/' |
        # Shorten names
        sed -Ee 's/<Andrew Burgess>/<me>/' |
        sed -Ee 's/<([^ >]+) [^>]*>/<\1>/' |
        # Line columns up based on } delimiter
        column -s '}' -t
}

function git_page_maybe() {
    # Page only if we're asked to.
    if [ -n "${GIT_NO_PAGER}" ]; then
        cat
    else
        # Page only if needed.
        less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS --chop-long-lines
    fi
}

function git_sparse_clone_branch() (
    rurl="$1" localdir="$2" branch="$3" && shift 3

    git clone "$rurl" --branch "$branch" --no-checkout "$localdir" --depth 1 # limit history
    cd "$localdir"

    # git sparse-checkout init --cone  # fetch only root file

    # Loops over remaining args
    for i; do
        git sparse-checkout set "$i"
    done

    git checkout "$branch"
)

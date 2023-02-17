#!/usr/bin/env bash

echo ''
info 'Creating link for .symlink files'

overwrite_all=false backup_all=false skip_all=false

for src in $(find -H "$DOTFILES" -maxdepth 2 -name '*.symlink' -not -path '*.git*'); do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
done

#!/usr/bin/env bash
# TODO use fpath or path to load all files from functions directory instead od sourcing like above

# for file in $($functions/*); do
#     chmod +x $file
#     # shellcheck source=/dev/null
#     source "$file"
# done

# fpath=($DOTFILES/functions $fpath)

# export after_brew="$DOTFILES/after_brew"

# for dir in $($after_brew/*); do
#     if [ -d $dir ]; then
#         fpath=($dir $fpath)
#     fi
# done

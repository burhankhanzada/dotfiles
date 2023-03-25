#!/usr/bin/env bash

export DOTFILES="$HOME/.dotfiles"

# shellcheck source=/dev/null
source "$DOTFILES/zsh/aliases.sh"

functions_path="$DOTFILES/functions"

# shellcheck source=/dev/null
source "$functions_path/color.zsh"

# shellcheck source=/dev/null
source "$functions_path/link.sh"

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

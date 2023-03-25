# function precmd() {
#     # shellcheck source=./aliases.sh
#     source "$DOTFILES/zsh/aliases.sh"
# }

# for topic_folder in $($DOTFILES/*); do
#     if [[ -d $topic_folder ]]; then
#         fpath=($topic_folder $fpath)
#     fi
# done

# fpath=($DOTFILES/functions $fpath)

# source_if_exists "$HOME/.env.sh"
# source_if_exists "$DOTFILES/zsh/git.zsh"
# source_if_exists "$DOTFILES/zsh/aliases.zsh"

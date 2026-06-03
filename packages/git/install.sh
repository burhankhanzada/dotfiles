#!/usr/bin/env bash

brew install git
brew install git-lfs
brew install gnupg
brew install git-secret
brew install git-filter-repo
git_username=$(git config --global user.name)
git_email=$(git config --global user.email)

if [[ -z "$git_username" ]]; then
    echo -n "Enter your Git user name: "
    read git_username
fi

if [[ -z "$git_email" ]]; then
    echo -n "Enter your Git email: "
    read git_email
fi

# Apply Git configuration
git config --global user.name "$git_username"
git config --global user.email "$git_email"
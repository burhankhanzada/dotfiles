#!/usr/bin/env bash

brew install git
brew install git-lfs
brew install gnupg
brew install git-secret
brew install git-filter-repo

echo -n "Enter your Git user name: "
read git_username

echo -n "Enter your Git email: "
read git_email

# Apply Git configuration
git config --global user.name "$git_username"
git config --global user.email "$git_email"
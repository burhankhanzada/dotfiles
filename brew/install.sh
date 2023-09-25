#!/usr/bin/env bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
) >>$HOME/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

brew tap homebrew/cask-versions

brew install mas

source $HOME/.zprofile


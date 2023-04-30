#!/usr/bin/env bash

# source files from fucntions so functions from these files eccessible from 
# every shell instance
for file in "$DOTFILES/functions/"*; do

    # calling script as part of this script process so no need to make them
    # executable
    source $file
done

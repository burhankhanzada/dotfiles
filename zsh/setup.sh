#!/usr/bin/env bash

echo "Running ZSH setup"

cd $DOTFILES/zsh

PATH=$(getconf PATH)

echo
echo "Reset \$PATH varaible to $PATH"
echo

# copying these files instead of symlink coz these files will be update by
# every program from after_brew folder which can add there export, alieases,
# functions and in future i went to remove that program i just need to remove
# that folder dont need to touch any thing else and run bootstrap again and
# it completeing reset the theses files
echo "Copying .zshrc from $DOTIFLES/zsh -> $HOME"
cp -f .zshrc $HOME/.zshrc

echo "Copying .zshenv from $DOTIFLES/zsh -> $HOME"
cp -f .zshenv $HOME/.zshenv

echo "Copying .zprofile from $DOTIFLES/zsh -> $HOME"
cp -f .zprofile $HOME/.zprofile

source $HOME/.zshrc
source $HOME/.zshenv
source $HOME/.zprofile

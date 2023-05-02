# Burhan Khanzada - dotfiles

Your dotfiles are how you personalize your system. These are mine.

## Structure

* ### functions

    In this directordy have utils files like in which have multiple fuctions in it

* ### zsh

    In this directory just zsh shell relatd files like aliases and sourcing files from functions directory so that fhuction avaiable in all shell

* ### mac_os

    In this directory scripts files to set and reset Defaults and NVRAM

* ### packages

    In this directory have nested directory with other files to install package setup, create symlink if needed

## Steps to bootstrap a new system

1. ### Clone the repo into new hidden directory

    ```sh
    git # it will try to install xcode tools first
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

2. ### Run bootstrap

    ```sh
    ~/.dotfiles/bootstrap.sh
    ```

## MacOS Preferences

* ### To set Mac OS default settings

    ```sh
    sudo ~/.dotfiles/mac_os/set_defaults.sh
    ```

* ### To reset Mac OS default settings

    ```sh
    sudo ~/.dotfiles/mac_os/reset_defaults.sh
    ```

## HomeBrew

* ### Update brewfile with currently installed pacakges

    ```sh
    cd ~/.dotfiles && brew bundle dump -f --describe
    ```

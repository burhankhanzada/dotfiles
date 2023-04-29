# Burhan Khanzada - dotfiles

Your dotfiles are how you personalize your system. These are mine.

## functions

In this directordy have like utils files in which have multiple fuctions in it

## zsh

In this directory just zsh shell relatd files and sourcing files from functions
& alises

## mac_os

In this scripts to set and reset defaults

## packages

In this directory have nested directory with other files to install package setup, create symlink if needed

## Steps to bootstrap a new system

### Witout Xcode Command Line Tools way

```sh
curl https://raw.githubusercontent.com/burhankhanzada/dotfiles/HEAD/bootstrap.sh && $HOME/.bootstrap.sh
```

### With Xcode Command Line Tools ways

1. Clone the repo into new hidden directory

    ```sh
    git # this will try to install xcode tools
    git clone https://github.com/burhankhanzada/dotfiles.git $HOME/.dotfiles
    ```

2. Run bootstrap

    ```sh
    sudo $HOME/.dotfiles/bootstrap.sh
    ```

### To set Mac OS default settings

```sh
sudo $HOME/.dotfiles/mac_os/set_defaults.sh
```

### To reset Mac OS default settings

```sh
sudo $HOME/.dotfiles/mac_os/reset_defaults.sh
```

### Update brewfile with currently installed pacakges

```sh
cd $HOME/.dotfiles && brew bundle dump -f --describe
```

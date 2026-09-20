# Burhan Khanzada - dotfiles

Your dotfiles are how you personalize your system. These are mine.

## Structure

* ### Brewfile

    Centralized Homebrew bundle declaring all CLI tools, development utilities, GUI casks, and Mac App Store applications.

* ### functions

    Shell utility functions for colors, safe symlinking, interactive prompts, and package installations.

* ### zsh

    Zsh shell configurations, environment exports, aliases, and automated function sourcing.

* ### mac_os

    Scripts to configure and reset macOS defaults, categorized into `ui.sh`, `finder.sh`, `hardware.sh`, and `system.sh`.

* ### packages

    Modular configurations, symlinks, and environment settings for development toolchains (git, VS Code, Antigravity IDE, Android CLI & ADB, Android Studio, Flutter, Python, Node, etc.).

## Steps to bootstrap a new system

1. ### Clone the repo into new hidden directory

    ```sh
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

2. ### Run bootstrap

    ```sh
    ~/.dotfiles/bootstrap.sh
    ```

## macOS Preferences

* ### To set macOS default settings

    ```sh
    ~/.dotfiles/mac_os/set_defaults.sh
    ```

* ### To reset macOS default settings

    ```sh
    ~/.dotfiles/mac_os/reset_defaults.sh
    ```

## Homebrew

* ### Install all declared packages

    ```sh
    brew bundle --file=~/.dotfiles/Brewfile
    ```

* ### Update Brewfile with currently installed packages

    ```sh
    cd ~/.dotfiles && brew bundle dump -f --describe
    ```

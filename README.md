# dotfiles

My MacOS dotfiles

## Steps to bootstrap a new system

1. Install Apple's Command Line Tools, which preequisties for Git & Homebrew

    ```cmd
    xcode-select --install
    ```

2. Clone the repo into new hidden directory

    ```cmd
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

3. Run bootstrap

    ```cmd
    cd ~/.dotfiles && script/bootstrap.sh
    ```

### To set Mac OS default settings

```sh
scripts/set_mac_os_defaults.sh
```

### Update brewfile with currently installed pacakges

```sh
brew bundle dump -f --describe
```

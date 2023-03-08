# dotfiles

My MacOS dotfiles

## Steps to bootstrap a new system

1. Install Apple's Command Line Tools, to get git

    ```cmd
    xcode-select --install
    ````

2. Clone the repo into new hidden directory

    ```cmd
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

3. Run bootstrap

    ```cmd
    cd ~/.dotfiles && ./bootstrap.sh
    ```

### To set Mac OS default settings

```sh
sudo ~/.dotfiles/scripts/mac_os_defaults/set.sh
```

### To reset Mac OS default settings

```sh
sudo ~/.dotfiles/scripts/mac_os_defaults/reset.sh
```

### Update brewfile with currently installed pacakges

```sh
cd ~/.dotfiles && brew bundle dump -f --describe
```

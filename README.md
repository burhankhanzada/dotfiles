# dotfiles

My MacOS dotfiles

## Steps to bootstrap a new system

### Witout Xcode Command Line Tools way

```sh
curl https://raw.githubusercontent.com/burhankhanzada/dotfiles/HEAD/bootstrap.sh && ~/.bootstrap.sh
```

### With Xcode Command Line Tools ways

1. Clone the repo into new hidden directory

    ```sh
    git # this will try to install xcode tools
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

2. Run bootstrap

    ```sh
    sudo .dotfiles/bootstrap.sh
    ```

### To set Mac OS default settings

```sh
sudo ~/.dotfiles/mac_os/set_defaults.sh
```

### To reset Mac OS default settings

```sh
sudo ~/.dotfiles/mac_os/reset_defaults.sh
```

### Update brewfile with currently installed pacakges

```sh
cd ~/.dotfiles && brew bundle dump -f --describe
```

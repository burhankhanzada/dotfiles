# dotfiles

My MacOS dotfiles

## Steps to bootstrap a new system

1. Install Apple's Command Line Tools, which preequisties for Git & Homebrew

    ```cmd
    xcode-select --install
    ```

2. Install & Setup Homebrew

    ```cmd
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> ~/.zprofile
    eval $(/opt/homebrew/bin/brew shellenv)
    ```

3. Clone the repo into new hidden directory

    ```cmd
    git clone https://github.com/burhankhanzada/dotfiles.git ~/.dotfiles
    ```

4. Run bootstrap

    ```cmd
    cd ~/.dotfiles && scripts/bootstrap.sh
    ```

### To set Mac OS default settings

```sh
scripts/set_mac_os_defaults.sh
```

### Update brewfile with currently installed pacakges

```sh
brew bundle dump -f --describe
```

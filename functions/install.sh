function installPackage() {

    local dir_name=$1

    export PACKAGES_PATH="$DOTFILES/packages"

    dir="$PACKAGES_PATH/$dir_name"
    cd "$dir"

    if [ -f "install.sh" ]; then
        echo
        echo.Blue "Installing from $dir/install.sh"
        chmod +x install.sh
        source "install.sh"
    fi

    if [ -f "enviornment_varaibles.sh" ]; then
        echo
        echo.Blue "Adding enviornment varaibles from $dir/enviornment_varaibles.sh"
        echo "source $dir/enviornment_varaibles.sh" >>~/.zshrc
    fi

    if [ -f "aliases.sh" ]; then
        echo
        echo.Blue "Adding aliases from $dir/aliases.sh"
        echo "source $dir/aliases.sh" >>~/.zshrc
    fi

    if [ -f "functions.sh" ]; then
        echo
        echo.Blue "Adding functions from $dir/functions.sh"
        echo "source $dir/functions.sh" >>~/.zshrc
    fi

    if [ -f "links.prop" ]; then
        echo
        echo.Blue "Linking from $dir/links.prop"
        link_files links.prop
    fi

    if [ -f "after_links.sh" ]; then
        echo
        echo.Blue "Running from $dir/after_links.sh"
        chmod +x after_links.sh
        source "after_links.sh"
    fi

    source ~/.zshenv
    source ~/.zshrc

    cd "$PACKAGES_PATH"
}
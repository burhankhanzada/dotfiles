function installPackage() {

    dir_name=$1

    update=false

    if [[ $2 == "--update" ]]; then
        update=true
    fi

    export PACKAGES_PATH="$DOTFILES/packages"

    dir="$PACKAGES_PATH/$dir_name"
    cd "$dir"

    # if [[ update == false ]]; then

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

        update $dir

    # else

    #     update $dir

    # fi

    source ~/.zshenv
    source ~/.zshrc

    cd "$PACKAGES_PATH"
}

function update() {

    dir=$1

    if [ -f "links.sh" ]; then
        echo
        echo.Blue "Running from $dir/links.sh"
        chmod +x links.sh
        source "links.sh"
    fi

    if [ -f "after_links.sh" ]; then
        echo
        echo.Blue "Running from $dir/after_links.sh"
        chmod +x after_links.sh
        source "after_links.sh"
    fi

}

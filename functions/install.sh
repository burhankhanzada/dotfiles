function installPackage() {

    dir_name=$1

    update=false

    if [[ "$*" == *"--update"* ]] || [[ "$*" == *"-u"* ]]; then
        update=true
    fi

    export PACKAGES_PATH="$DOTFILES/packages"

    dir="$PACKAGES_PATH/$dir_name"
    cd $dir

    if [[ $update == false ]]; then

        if [ -f "install.sh" ]; then
            echo
            echo.Blue "Installing from $dir/install.sh"
            chmod +x install.sh
            source "install.sh"
        fi

        env_file=""
        if [ -f "environment_variables.sh" ]; then
            env_file="environment_variables.sh"
        elif [ -f "environment_varaibles.sh" ]; then
            env_file="environment_varaibles.sh"
        elif [ -f "enviornment_varaibles.sh" ]; then
            env_file="enviornment_varaibles.sh"
        fi

        if [ -n "$env_file" ]; then
            echo
            echo.Blue "Adding environment variables from $dir/$env_file"
            if ! grep -qs "source $dir/$env_file" ~/.zshrc 2>/dev/null; then
                echo "source $dir/$env_file" >>~/.zshrc
            fi
        fi

        if [ -f "aliases.sh" ]; then
            echo
            echo.Blue "Adding aliases from $dir/aliases.sh"
            if ! grep -qs "source $dir/aliases.sh" ~/.zshrc 2>/dev/null; then
                echo "source $dir/aliases.sh" >>~/.zshrc
            fi
        fi

        if [ -f "functions.sh" ]; then
            echo
            echo.Blue "Adding functions from $dir/functions.sh"
            if ! grep -qs "source $dir/functions.sh" ~/.zshrc 2>/dev/null; then
                echo "source $dir/functions.sh" >>~/.zshrc
            fi
        fi

        update $dir

    else
        update $dir
    fi

    source ~/.zshrc
    source ~/.zshenv

    cd $PACKAGES_PATH
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

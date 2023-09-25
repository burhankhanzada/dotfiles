function runDefaults() {

    file_name=$1

    export DEFAULTS_PATH="$DOTFILES/mac_os/defaults"

    file_path="$DEFAULTS_PATH/$file_name.sh"
    cd $dir

    echo.Blue "Running $file_path"
    source $file_path

}

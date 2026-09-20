function runDefaults() {

    file_name=$1

    export DEFAULTS_PATH="$DOTFILES/mac_os/defaults"

    file_path="$DEFAULTS_PATH/$file_name.sh"

    if [ -f "$file_path" ]; then
        cd "$DEFAULTS_PATH"
        command -v echo.Blue &>/dev/null && echo.Blue "Running $file_path" || echo "Running $file_path"
        source "$file_path"
    else
        echo "Defaults file not found: $file_path"
    fi
}

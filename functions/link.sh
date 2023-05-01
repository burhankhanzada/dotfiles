#!/usr/bin/env bash

overwrite_all=false
backup_all=false
skip_all=false

function link_file() {
    local src=$1
    local dst=$2

    currentSrc=$(readlink $dst)

    if [ $currentSrc ]; then

        echo.Yellow "Link already exists for $dst -> $src"

        if [ $currentSrc != $src ]; then
            sudo ln -sf $src $dst
            echo.Green "Link updated $src -> $dst"
        fi

    else

        if [[ -e "$dst" && -e "$src" ]]; then

            sudo chown -R $(whoami) $src

            echo.Yellow "Destination: \"$dst\" and Source: \"$src\" both exists"
            rm -r $dst
            echo.Red "Deletd Destination: \"$dst\""
        fi

        if [ -e "$dst" ]; then

            echo.Yellow "Destination: \"$dst\" exists"

            if [ -f "$dst" ]; then

                dir=$(dirname $src)
                base=$(basename $src)

                echo.Purple "Parent Directory: $dir"
                echo.Purple "Filaname: $base"

                mv $dst $dir

            else
                mv $dst $src
            fi

            echo.Blue "Destination: \"$dst\" moved to Source: \"$src\""
            sudo ln -s $src $dst
            echo.Green "New Link created $src -> $dst"

        elif [ -e $src ]; then

            sudo chown -R $(whoami) $src

            echo.Yellow "Source: \"$src\" exists"

            sudo ln -s $src $dst
            echo.Green "New Link created $dst -> $src"
        fi
    fi
}

function link_files() {

    local linkfile=$1

    cat "$linkfile" | while read line; do

        local src
        local dst
        local dir

        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)

        mkdir -p "$dir"
        link_file "$src" "$dst"
    done

}

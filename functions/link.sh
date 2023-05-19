#!/usr/bin/env bash

overwrite_all=false
backup_all=false
skip_all=false

function link_file() {

    local src=$1
    local dst=$2

    currentSrc=$(readlink $dst)

    if [ $currentSrc ]; then

        echo.Yellow "Link already exists for $dst -> $currentSrc"

        if [ $currentSrc != $src ]; then

            echo.Yellow "New source is differnt $src"

            if [ -e $src ]; then

                # sudo chown -R $(whoami) $src

                echo.Yellow "Source: \"$src\" exists"

                ln -sf $src $dst
                if [ $? -eq 0 ]; then
                    echo.Green "Link updated $src -> $dst"
                fi

            else

                echo.Red "New Source $src does not exits"

            fi

        fi

    else

        if [[ -e "$dst" && -e "$src" ]]; then

            # sudo chown -R $(whoami) $src

            echo.Yellow "Both Destination: \"$dst\" and Source: \"$src\" exists"

            sudo rm -rf $dst
            if [ $? -eq 0 ]; then
                echo.Red "Deleted Destination: \"$dst\""
            fi

            sudo ln -s $src $dst
            if [ $? -eq 0 ]; then
                echo.Green "New Link created $dst -> $src"
            fi

        elif [ -e "$dst" ]; then

            echo.Yellow "Destination: \"$dst\" exists"

            dir=$(dirname $src)
            base=$(basename $src)

            if [ -f "$dst" ]; then

                echo.Purple "Parent Directory: $dir"
                echo.Purple "Filaname: $base"

                sudo mv $dst $dir
                if [ $? -eq 0 ]; then
                    echo.Green "Destination moved from $dst -> $src"
                fi

            else
                mkdir -p $src
                sudo mv $dst $dir
                if [ $? -eq 0 ]; then
                    echo.Green "Destination moved from $dst -> $src"
                fi
            fi

            echo.Blue "Only Destination: \"$dst\" moved to Source: \"$src\""
            sudo ln -s $src $dst
            if [ $? -eq 0 ]; then
                echo.Green "New Link created $src -> $dst"
            fi

        elif [ -e $src ]; then

            # sudo chown -R $(whoami) $src

            echo.Yellow "Only Source: \"$src\" exists"

            ln -s $src $dst
            if [ $? -eq 0 ]; then
                echo.Green "New Link created $dst -> $src"
            fi
        else

            echo.Yellow "Both Destination: \"$dst\" and Source: \"$src\" does not exists"

        fi
    fi
}

function link_files() {

    local linkfile=$1

    cat "$linkfile" | while read line; do

        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)

        mkdir -p "$dir"
        link_file "$src" "$dst"
    done

}

#!/usr/bin/env bash

function continueAbort() {

    title=$1

    echo
    echo.Yellow $title
    echo.Magenta "Press RETURN/ENTER to continue or any other key to abort"
    read -n 1 key

    if [[ $key = "" ]]; then

        if [ -z "${3+set}" ]; then

            source $2

        else
            source $2 $3
        fi
    else
        echo
        echo.Red "Aborted"
    fi

}

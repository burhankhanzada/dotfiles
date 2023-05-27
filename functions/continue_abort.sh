#!/usr/bin/env bash

function continueAbortCommand() {

    command=$1

    echo
    echo.Yellow $command

    echo.Magenta "Press RETURN/ENTER to continue run above command or any other key to abort"

    read -n 1 key

    if [[ $key = "" ]]; then
        eval "$command"
    else
        echo
        echo.Red "Aborted"
    fi
}

function continueAbortSourceFile() {

    title=$1

    echo
    echo.Yellow $title

    echo.Magenta "Press RETURN/ENTER to continue run above file or any other key to abort"

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

#!/usr/bin/env bash

for FILE in mac_os_defaults/*; do

    echo ''
    echo "Running $FILE"

    # calling script as part of this script process so no need to make them executable
    source $FILE
done

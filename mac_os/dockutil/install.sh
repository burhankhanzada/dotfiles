#!/usr/bin/env bash

file_name=dockutil-3.0.2.pkg
file_path=$MAC_OS_PATH/dockutil/$file_name

# downloadFile kcrawford dockutil $file_name $file_path

sudo installer -pkg $file_path -target /usr/local/bin

export PATH=/usr/local/bin:$PATH
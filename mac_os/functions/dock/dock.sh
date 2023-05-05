#!/usr/bin/env bash

file_name=dockutil-3.0.2.pkg
file_path=$DOTFILES/mac_os/functions/dock/$file_name

# downloadFile kcrawford dockutil $file_name $file_path

sudo installer -pkg $file_path -target /usr/local/bin

export PATH=/usr/local/bin:$PATH

dockutil --remove Safari --no-restart
dockutil --remove Messages --no-restart
dockutil --remove Mail --no-restart
dockutil --remove Maps --no-restart
dockutil --remove Photos --no-restart
dockutil --remove FaceTime --no-restart
dockutil --remove Calendar --no-restart
dockutil --remove Contacts --no-restart
dockutil --remove Reminders --no-restart
dockutil --remove Notes --no-restart
dockutil --remove Freeform --no-restart
dockutil --remove TV --no-restart
dockutil --remove Music --no-restart
dockutil --remove News --no-restart
dockutil --remove Keynote --no-restart
dockutil --remove Numbers --no-restart
dockutil --remove Pages --no-restart
dockutil --remove "App Store" --no-restart
dockutil --remove "System Settings" --no-restart
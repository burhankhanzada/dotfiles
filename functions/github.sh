#!/usr/bin/env bash

function downloadFile() {

    owner=$1
    repo=$2
    file_prefix=$3
    file_extension=$4
    save_path=$5

    latest=https://api.github.com/repos/$owner/$repo/releases/latest

    echo $latest

    version=$(curl -s $latest | jq -r '.tag_name')

    echo $version

    file_name="$file_prefix-$version.$file_extension"

    echo $file_name

    download=https://github.com/$owner/$repo/releases/download

    echo $download

    download=$download/$version/$file_name

    echo $download

    download_url=$(curl -s $github_url | jq -r '.assets[].browser_download_url' | grep -i $asset_prefix)
    # download_url=$(curl -s "$download/$version/$file_name" )

    echo $download_url

    # https://github.com/fluttertools/sidekick/releases/download/1.1.1/sidekick-macos-1.1.1.dmg

    # asset_name=$(echo $download_url | awk -F'/' '{print $NF}')

    # echo $asset_name

    # file_name="$asset_prefix-$version.$asset_ext"

    # echo $file_name

    # LATEST_TAG=$(curl --silent "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    # URL="https://github.com/$OWNER/$REPO/releases/download/$LATEST_TAG/$FILENAME"

    curl -LJ "$download_url" -o "$save_path"
}

# source /Users/burhankhanzada/.dotfiles/functions/github.sh

# downloadFile fluttertools sidekick sidekick-macos dmg ~/Development

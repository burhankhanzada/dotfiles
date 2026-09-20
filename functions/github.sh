#!/usr/bin/env bash

function downloadFile() {
    local owner=$1
    local repo=$2
    local file_prefix=$3
    local file_extension=$4
    local save_path=$5

    local latest_url="https://api.github.com/repos/$owner/$repo/releases/latest"
    local release_json
    release_json=$(curl -s "$latest_url")

    local version
    version=$(echo "$release_json" | jq -r '.tag_name // empty')

    if [ -z "$version" ]; then
        echo "Error: Could not fetch latest release for $owner/$repo"
        return 1
    fi

    # Find matching asset URL by prefix and extension
    local download_url
    download_url=$(echo "$release_json" | jq -r --arg prefix "$file_prefix" --arg ext "$file_extension" \
        '.assets[]?.browser_download_url | select(contains($prefix) and endswith($ext))' | head -1)

    # Fallback to direct download URL if not found in assets array
    if [ -z "$download_url" ]; then
        local file_name="$file_prefix-$version.$file_extension"
        download_url="https://github.com/$owner/$repo/releases/download/$version/$file_name"
    fi

    echo "Downloading $download_url -> $save_path"
    curl -fLJ "$download_url" -o "$save_path"
}

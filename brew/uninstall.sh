#!/usr/bin/env bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

rmdir $HOME/Developemtn/Homebrew
rmdir /opt/Homebrew
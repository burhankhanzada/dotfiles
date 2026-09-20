#!/usr/bin/env bash

# Fallback for echo.Green if run standalone
command -v echo.Green &>/dev/null || echo.Green() { echo -e "\033[0;32m$*\033[0m"; }

echo.Green "1 - Enable system sleep"
sudo pmset -a disablesleep 0

echo.Green "2 - Set display sleep to 15 min on battery and 30 min on charger"
sudo pmset -b displaysleep 15
sudo pmset -c displaysleep 30
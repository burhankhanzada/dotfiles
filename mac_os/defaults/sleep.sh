#!/usr/bin/env bash

echo.Green "1 - Enable sleep"
sudo pmset -a disablesleep 0

echo.Green "2 - Disable sleep"
sudo pmset -a disablesleep 1
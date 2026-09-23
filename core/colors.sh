#!/usr/bin/env bash
# High-performance, clean ANSI color and logging helpers.
# Portable across bash, zsh, and POSIX shells.

# Reset
COLOR_RESET="\033[0m"

# Regular Colors
COLOR_BLACK="\033[0;30m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"
COLOR_CYAN="\033[0;36m"
COLOR_WHITE="\033[0;37m"

# Bold Colors
COLOR_BOLD_BLACK="\033[1;30m"
COLOR_BOLD_RED="\033[1;31m"
COLOR_BOLD_GREEN="\033[1;32m"
COLOR_BOLD_YELLOW="\033[1;33m"
COLOR_BOLD_BLUE="\033[1;34m"
COLOR_BOLD_MAGENTA="\033[1;35m"
COLOR_BOLD_CYAN="\033[1;36m"
COLOR_BOLD_WHITE="\033[1;37m"

# Logging Functions
echo.Red() { echo -e "${COLOR_RED}$*${COLOR_RESET}"; }
echo.BoldRed() { echo -e "${COLOR_BOLD_RED}$*${COLOR_RESET}"; }

echo.Green() { echo -e "${COLOR_GREEN}$*${COLOR_RESET}"; }
echo.BoldGreen() { echo -e "${COLOR_BOLD_GREEN}$*${COLOR_RESET}"; }

echo.Yellow() { echo -e "${COLOR_YELLOW}$*${COLOR_RESET}"; }
echo.BoldYellow() { echo -e "${COLOR_BOLD_YELLOW}$*${COLOR_RESET}"; }

echo.Blue() { echo -e "${COLOR_BLUE}$*${COLOR_RESET}"; }
echo.BoldBlue() { echo -e "${COLOR_BOLD_BLUE}$*${COLOR_RESET}"; }

echo.Magenta() { echo -e "${COLOR_MAGENTA}$*${COLOR_RESET}"; }
echo.BoldMagenta() { echo -e "${COLOR_BOLD_MAGENTA}$*${COLOR_RESET}"; }

echo.Cyan() { echo -e "${COLOR_CYAN}$*${COLOR_RESET}"; }
echo.BoldCyan() { echo -e "${COLOR_BOLD_CYAN}$*${COLOR_RESET}"; }

echo.Purple() { echo.Magenta "$@"; }
echo.BoldPurple() { echo.BoldMagenta "$@"; }
echo.White() { echo -e "${COLOR_WHITE}$*${COLOR_RESET}"; }
echo.BoldWhite() { echo -e "${COLOR_BOLD_WHITE}$*${COLOR_RESET}"; }

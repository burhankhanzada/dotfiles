#!/usr/bin/env bash

function check_sudo_auth() {
  sudo -n true 2>/dev/null
}F
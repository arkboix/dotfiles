#!/bin/bash
# Arkscripts - https://github.com/arkboix/dotfiles

notify-send "System Updates" "System is updating, please wait"
pkexec pacman -Syu --noconfirm
notify-send "System Updates" "Update Complete"

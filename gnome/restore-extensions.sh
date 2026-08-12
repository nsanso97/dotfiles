#!/bin/bash
# Restores GNOME Shell extension settings dumped from dconf.
# Run from any directory; loads each dump back into its dconf path.

cd "$(dirname "$(realpath "$0")")"

dconf load /org/gnome/shell/extensions/pop-shell/ < extensions-pop-shell.ini
dconf load /org/gnome/shell/extensions/blur-my-shell/ < extensions-blur-my-shell.ini

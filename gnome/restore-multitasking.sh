#!/bin/bash
# Restores GNOME multitasking (workspaces) and hot corner settings.
# Run from any directory; loads each dump back into its dconf path.

cd "$(dirname "$(realpath "$0")")"

dconf load /org/gnome/mutter/ < multitasking-mutter.ini
dconf load /org/gnome/desktop/wm/preferences/ < multitasking-wm-preferences.ini
dconf write /org/gnome/desktop/interface/enable-hot-corners false

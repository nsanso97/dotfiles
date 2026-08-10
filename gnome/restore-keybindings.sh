#!/bin/bash
# Restores custom GNOME keyboard shortcuts dumped from dconf.
# Run from any directory; loads each dump back into its dconf path.

cd "$(dirname "$(realpath "$0")")"

dconf load /org/gnome/desktop/wm/keybindings/ < wm-keybindings.ini
dconf load /org/gnome/shell/keybindings/ < shell-keybindings.ini
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < media-keys.ini

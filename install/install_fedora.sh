#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root." >&2
	exit 1
fi

dnf install -y \
	gnome-shell-extension-pop-shell \
	gnome-shell-extension-blur-my-shell \
	neovim \
	cascadia-code-nf-fonts

dnf copr enable -y pgdev/ghostty
dnf install -y ghostty

USER_ID=$(id -u "$SUDO_USER")
sudo -u "$SUDO_USER" XDG_RUNTIME_DIR="/run/user/$USER_ID" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" gnome-extensions enable pop-shell@system76.com
sudo -u "$SUDO_USER" XDG_RUNTIME_DIR="/run/user/$USER_ID" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" gnome-extensions enable blur-my-shell@aunetx

echo "Restart the GNOME session for the extensions to take effect."

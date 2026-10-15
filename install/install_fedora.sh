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
	cascadia-code-nf-fonts \
	gnome-shell-extension-appindicator \
  fzf \
  ripgrep \
  jq

dnf install -y wl-clipboard
dnf install -y xclip

dnf copr enable -y scottames/ghostty
dnf install -y ghostty

echo "Restart the GNOME session for the extensions to take effect."

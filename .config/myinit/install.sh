#!/bin/bash

LOGNAME=$(logname)

# Update and install tools

dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf update -y

dnf group install -y "C Development Tools and Libraries" "Development Tools"

dnf install -y \
	neovim \
	rofi \
	alacritty \
	arandr \
	xset \
	xinput \
	ripgrep \
	flatpak \
	picom \
	polybar \
	zstd \
	maim \
	xclip \
	tldr

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

test -f $LOGNAME/.asdf/asdf.sh || git clone https://github.com/asdf-vm/asdf.git /home/$LOGNAME/.asdf

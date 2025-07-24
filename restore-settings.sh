#!/usr/bin/env bash
set -euo pipefail
SRC=$HOME/linux_backup

# 2.1 configs
sudo tar xzf "$SRC"/config_*.tar.gz -C / --preserve-permissions

# 2.2 packages
xargs -a "$SRC/apt.clean" sudo apt-get install -y
while read -r s;  do sudo snap install   "$s"; done < "$SRC/snap.txt"
while read -r f;  do flatpak install -y flathub "$f"; done < "$SRC/flatpak.txt"
pip install -r "$SRC/pip.txt"


#!/usr/bin/env bash
set -euo pipefail

DEST=$HOME/sys-backup           # any folder, version‑control it afterwards
mkdir -p "$DEST"

## Package lists
apt-mark showmanual | sort > "$DEST/apt.txt"            # APT
snap list --all | awk 'NR>1{print $1}' > "$DEST/snap.txt"
flatpak list --app --columns=application > "$DEST/flatpak.txt"
pip freeze --local > "$DEST/pip.txt"


## Config archives
sudo tar czf "$DEST/config_$(date +%F).tar.gz" \
	  --preserve-permissions \
	  --checkpoint=.100 \
	  --exclude="$HOME/.config/google-chrome*" \
	  --exclude="$HOME/.config/Code*" \
	  --exclude="$HOME/.local/share/Trash*" \
	  /etc \
	  "$HOME/.config" \
	  "$HOME/.local/share" \
	  "$HOME"/.bash* "$HOME"/.zsh* "$HOME"/.gitconfig \
	  "$HOME/.config/systemd/user"


## Commit to Git 
cd "$DEST"
git init -q 2>/dev/null || true
git add .
git commit -qm "snapshot $(date -I)"
git remote add origin git@github.com:romanmikh/linux_backup.git   # once
git push -q


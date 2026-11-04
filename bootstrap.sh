#!/bin/bash

# Bootstrap for Alex's shell config
# Setup the dotfiles
REPO="https://github.com/gateway240/dotfiles.git"
TARGET_DIR="$HOME/.dotfiles"

# Functions
conf() {
	/usr/bin/git --git-dir="$TARGET_DIR" --work-tree="$HOME" "$@"
}

# Main script begins
if [[ ! -d "$TARGET_DIR" ]]; then
	git clone --bare "$REPO" "$TARGET_DIR"
	conf config --local status.showUntrackedFiles no
	conf checkout
else
	conf pull
fi

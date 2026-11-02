#!/bin/bash

# Bootstrap for Alex's shell config
# Setup the dotfiles
REPO="https://github.com/gateway240/dotfiles.git"
TARGET_DIR="$HOME/.dotfiles"
conf() {
	/usr/bin/git --git-dir="$TARGET_DIR" --work-tree="$HOME" "$@"
}
if [[ ! -d "$TARGET_DIR" ]]; then
    git clone --bare "$REPO" "$TARGET_DIR"
fi
conf config --local status.showUntrackedFiles no
conf checkout

# Install platform specific tooling
install_homebrew_if_not_present() {
    echo "Checking for Homebrew installation"

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed! Updating..."
        brew update
    fi
}
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Installing Linux dependencies!"
        # ...
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing macOS dependencies!"
	# Install homebrew
	install_homebrew_if_not_present
	# Install specific dependencies
	brew install --cask ghostty 
	brew install neovim tmux screen
	
elif [[ "$OSTYPE" == "cygwin" ]]; then
	echo "Installing POSIX dependencies!"
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
	echo "Installing Windows dependencies!"
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
	echo "Installing Windows32 dependencies!"
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
	echo "Installing FreeBSD dependencies!"
        # ...
else
	echo "UNKNOWN dependencies!"
        # Unknown.
fi


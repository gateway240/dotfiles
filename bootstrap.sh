#!/bin/bash

# Bootstrap for Alex's shell config
# Setup the dotfiles
REPO="https://github.com/gateway240/dotfiles.git"
TARGET_DIR="$HOME/.dotfiles"
alias config='/usr/bin/git --git-dir=$TARGET_DIR --work-tree=$HOME'
git clone --bare $REPO $HOME/.dotfiles || true
config config --local status.showUntrackedFiles no
config checkout

# Install platform specific tooling
#
# Source - https://stackoverflow.com/a/43027113
# Posted by ccpizza
# Retrieved 2026-11-02, License - CC BY-SA 3.0

install_homebrew_if_not_present() {
    echo "Checking for homebrew installation"
    which -s brew
    if [[ $? != 0 ]] ; then
        echo "Homebrew not found. Installing..."
				"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed! Updating..."
        brew update
    fi
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # ...
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing macOS dependencies!"
	# Install homebrew
	install_homebrew_if_not_present()
	# Install specific dependencies
	brew install --cask ghostty 
	brew install neovim
	
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
fi


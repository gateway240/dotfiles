#!/bin/bash

# Bootstrap for Alex's shell config
# Setup the dotfiles
REPO="https://github.com/gateway240/dotfiles.git"
TARGET_DIR="$HOME/.dotfiles"
main_packages=(
	neovim
	tmux
	screen
	stylua
	shfmt
)
aur_packages=(
	dockerfmt
)
linux_specific_packages=(
	ghostty
	zsh
)

# Functions
conf() {
	/usr/bin/git --git-dir="$TARGET_DIR" --work-tree="$HOME" "$@"
}

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

# Main script begins
if [[ ! -d "$TARGET_DIR" ]]; then
	git clone --bare "$REPO" "$TARGET_DIR"
	conf config --local status.showUntrackedFiles no
	conf checkout
else
	conf pull
fi

# Install packages
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Installing Linux dependencies!"
	# Detect installed package managers
	package_managers=("apt" "yum" "dnf" "zypper" "pacman" "snap" "flatpak")
	echo "Installed package managers on this Linux system:"
	for manager in "${package_managers[@]}"; do
		if command -v "$manager" >/dev/null 2>&1; then
			echo "-$manager"
		fi
	done

	# Detect distro
	if [[ -f /etc/os-release ]]; then
		distro=$(source /etc/os-release && echo $NAME)
	else
		distro="*Unknown*"
	fi
	echo "Detected distro: $distro"

	# Default package manager, if any
	echo -n "Default distro package manager: "
	if [[ "$distro" == "Ubuntu" || "$distro" == "Debian" || "$distro" == "Linux Mint" ]]; then
		echo "apt"
	elif [[ "$distro" == "Fedora" || "$distro" == "Red Hat"* ]]; then
		echo "dnf"
		dnf install -y "${linux_specific_packages[@]}" "${main_packages[@]}"

	elif [[ "$distro" == "CentOS" ]]; then
		echo "yum"
	elif [[ "$distro" == "Arch Linux" || "$distro" == "Manjaro" ]]; then
		echo "pacman"
		sudo pacman -Syu "${linux_specific_packages[@]}" "${main_packages[@]}"
		paru -Syu "${aur_packages[@]}"

	elif [[ "$distro" == "openSUSE" ]]; then
		echo "zypper"
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing macOS dependencies!"
	# Install homebrew
	install_homebrew_if_not_present
	# Install specific dependencies
	brew install --cask ghostty
	brew install "${main_packages[@]}"

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

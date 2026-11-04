#!/bin/bash

# Install packages
main_packages=(
	neovim
	tmux
	screen
)
format_packages=(
	dockerfmt
	stylua
	shfmt
	lua-language-server
)
linux_specific_packages=(
	zsh
)

# Functions

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
	elif [[ "$distro" == "Fedora" || "$distro" == "Red Hat"* || "$distro" == "AlmaLinux" ]]; then
		echo "dnf"
		# The version of nvim installed with AlmaLinux is 0.8 which is far too old
		unset "main_packages[0]"
		dnf install -y "${linux_specific_packages[@]}" "${main_packages[@]}"
		# Install modern nvim from tarball
		curl -LO https://github.com/neovim/neovim-releases/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz
		tar -C /opt -xzf nvim-linux-x86_64.tar.gz
		ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

	elif [[ "$distro" == "CentOS" ]]; then
		echo "yum"
	elif [[ "$distro" == "Arch Linux" || "$distro" == "Manjaro" ]]; then
		echo "pacman"
		sudo pacman -Syu "${main_packages[@]}" "${linux_specific_packages[@]}" ghostty
		paru -Syu "${format_packages[@]}"

	elif [[ "$distro" == "openSUSE" ]]; then
		echo "zypper"
	fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo "Installing macOS dependencies!"
	# Install homebrew
	install_homebrew_if_not_present
	# Install specific dependencies
	brew install --cask ghostty
	brew install "${main_packages[@]}" "${format_packages[@]}"

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

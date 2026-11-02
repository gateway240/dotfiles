#!/bin/bash
set -e

echo "==> Installing ZSH..."
sudo apt install zsh
echo "==> Installing Neovim..."
if ! command -v nvim &> /dev/null; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo tar -xzf nvim-linux64.tar.gz -C /opt
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
fi

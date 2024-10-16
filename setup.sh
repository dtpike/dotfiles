#!/bin/bash

SCRIPT_PATH=$(readlink -f $0)
DOTFILES_ROOT=$(dirname $SCRIPT_PATH)

echo "Installing dotfiles from ${DOTFILES_ROOT}..."

mkdir -p ${HOME}/.config/nvim/
ln -sf ${DOTFILES_ROOT}/init.lua ${HOME}/.config/nvim/init.lua
ln -sf ${DOTFILES_ROOT}/zshrc ${HOME}/.zshrc
ln -sf ${DOTFILES_ROOT}/tmux.conf ${HOME}/.tmux.conf
ln -sf ${DOTFILES_ROOT}/p10k.zsh ${HOME}/.p10k.zsh

# Copy gitconfig if there isn't an existing one
cp -n ${DOTFILES_ROOT}/gitconfig ${HOME}/.gitconfig

# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

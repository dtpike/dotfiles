#!/bin/bash

SCRIPT_PATH=$(readlink -f $0)
DOTFILES_ROOT=$(dirname $SCRIPT_PATH)

echo "Installing dotfiles from ${DOTFILES_ROOT}..."

ln -sf ${DOTFILES_ROOT}/init.vim ${HOME}/.config/nvim/init.vim
ln -sf ${DOTFILES_ROOT}/init.vim ${HOME}/.vimrc
ln -sf ${DOTFILES_ROOT}/zshrc ${HOME}/.zshrc
ln -sf ${DOTFILES_ROOT}/tmux.conf ${HOME}/.tmux.conf

# Copy gitconfig if there isn't an existing one
cp -n ${DOTFILES_ROOT}/gitconfig ${HOME}/.gitconfig

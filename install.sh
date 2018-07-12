#!/bin/bash

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Makes the backup directory
BACKUPS_DIR="$DOTFILES_DIR/backup/"
mkdir -p $BACKUPS_DIR

DOTFILES_LIST=(
  ".bashrc"
)

# Backing up every files in the DOTFILES_LIST
echo "started backing up the files before linking them"
for i in "${DOTFILES_LIST[@]}"; do
  echo "backing up $i"
  cp -f $HOME/$i $BACKUPS_DIR
done

# Making the symbolic link
echo -e "\nstarted linking files"
for i in "${DOTFILES_LIST[@]}"; do
  echo -n "made a symbolic link for $i "
  ln -sfv $DOTFILES_DIR/$i ~
done

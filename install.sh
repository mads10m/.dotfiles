#!/bin/bash

# Get the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

# Makes the backup directory
BACKUPS_DIR="$DOTFILES_DIR/backup/"
mkdir -p $BACKUPS_DIR

CONFIG_FILES_DIR="$DOTFILES_DIR/config-files"

# List of dotfiles
DOTFILES_LIST=(
".bash_aliases"
".bashrc"
".profile"
".tmux.conf"
".vimrc"
)

# Colors name
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_RESET="\033[0m"

# Warning message
WARNING_MESSAGE="${COLOR_RED}WARNING:${COLOR_RESET}"


# Backing up files
echo -e "${COLOR_GREEN}backing up the config files${COLOR_RESET}"
for i in "${DOTFILES_LIST[@]}"; do
	# Test if file exist
	if [ -f ~/$i ]
	then
		# File exist
		echo "backing up $i"
		cp -f $HOME/$i $BACKUPS_DIR
	else
		# File doesn't exist
		echo -e "${COLOR_RED}${i} does not already exist!${COLOR_RESET}"
	fi
done

# Making the symbolic link
echo -e "${COLOR_GREEN}making symbolic links${COLOR_RESET}"
for i in "${DOTFILES_LIST[@]}"; do
	echo -n "made a symbolic link for $i "
	ln -sfv $CONFIG_FILES_DIR/$i ~/$i
done

# Downloading the scripts repo
SCRIPTS_DIR="$HOME/.scripts"
if [ -d "$SCRIPTS_DIR" ]; then
	echo -e "$WARNING_MESSAGE $HOME/.scripts does already exist"
else
	echo -e "${COLOR_GREEN}cloning scripts${COLOR_RESET}"
	git clone https://github.com/mads10m/.scripts.git ~/.scripts
fi

# Donloading the .vim repo
VIM_DIR="$HOME/.vim"
if [ -d "$VIM_DIR" ]; then
	echo -e "$WARNING_MESSAGE $HOME/.vim does already exist"
else
	echo -e "${COLOR_GREEN}Cloning .vim${COLOR_RESET}"
	git clone https://github.com/mads10m/.vim.git ~/.vim
fi

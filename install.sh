#! /usr/bin/env bash

dotfiles_home=$(pwd)

# first install all apps/package...
#bootstrap/init.sh

# then link everything to the home directory
util/link_everything.sh -f $dotfiles_home/links $HOME 
util/link_everything.sh -f -i $dotfiles_home/links-in-depth $HOME 

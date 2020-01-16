#! /usr/bin/env bash

dry_run=0

# extract parameters
while test $# -gt 0
do
	case "$1" in
		--dry-run) dry_run=1
			;;
	esac
	shift
done

dotfiles_home=$(pwd)

boot_options=""
if [[ ${dry_run} == 1 ]]; then
	boot_options="--dry-run"
fi

# first install all apps/package...
bash bootstrap/boot.sh ${boot_options}

# then link everything to the home directory
optional_options=""
if [[ ${dry_run} == 1 ]]; then
	optional_options="-d"
fi

util/link_everything.sh -f -v ${optional_options} $dotfiles_home/links $HOME
util/link_everything.sh -f -i -v ${optional_options} $dotfiles_home/links-in-depth $HOME

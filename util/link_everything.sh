#! /usr/bin/env bash
#
# For all files in source directory, create a sym link in the destination 
# directory. It will search for files in depth

function usage() {
	echo "link_everything.sh [src] [dest]"
}

function link_file() {
	local src="$1"
	local file="$2"
	local base_dest="$3"
	local force="$4"
	local verbose="$5"

	options="-sf"
	if [[ $force ]]; then
		options="-sfn"
	fi

	prefix=${src//\//\\/}
	relative_dest=$(sed "s/$prefix//" <<< $file)
	absolute_dest=$(echo "$base_dest$relative_dest")

	[[ $verbose ]] && echo "-> create a sym link for $file into $absolute_dest"
	base_dir=$(dirname $absolute_dest)
	[[ ! -a $base_dir ]] && mkdir -p $base_dir	
	ln $options $file $absolute_dest
}

# analyze command line
force=0
verbose=0

while getopts ":fv" option; do
	case $option in
		f ) force=1; shift ;;
		v ) verbose=1; shift ;;
	esac
done

src=$1
dest=$2

if [[ -z "$src" || -z "$dest" ]]; then
	usage;
	exit -1;
fi

[[ $verbose ]] && echo "==> link all files from $src to $dest (options: force=$force)"

files=$(find $src -type f)
for file in $files; do
	link_file $src $file $dest $force $verbose
done


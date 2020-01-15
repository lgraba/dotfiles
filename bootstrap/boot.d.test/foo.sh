#!/usr/bin/env bash

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

if [[ ${dry_run} == 1 ]]; then
	echo "dry run mode!!!"
else
	echo "normal mode..."
fi

echo "foobar!"
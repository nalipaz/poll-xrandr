#!/bin/bash

# Take in argument for the path to monitor, usually a status file under /sys
f=$1
command=$2
i=4 # default interval for polling.

# Store the original status for comparisons
cat="`cat $f`"

# Endless loop
while : ; do
	# Re-read the status
	new_cat="`cat $f`"

	# If original contents don't match new we need to run command.
	if [ "$cat" != "$new_cat" ]; then
		# Set the original contents the same as new to avoid unnecessarily repeating
		cat=$new_cat
		$command
	fi

	shift 2
	while [[ $# > 0 ]]; do
		key=$1

		case $key in
			-i=*|--interval=*)
				i="${key#*=}"
				;;
			*)
				echo "Unknown option provided, you should fix that."
				;;
		esac
		shift
	done

	sleep $i
done

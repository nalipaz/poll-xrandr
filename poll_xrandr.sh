#!/bin/bash

command=$1
i=4 # default interval for polling.

connected="$(xrandr -q | grep " connected"|cut -d ' ' -f1|xargs)"

# Endless loop
while : ; do
	# Re-read the status
	#new_cat="`cat $f`"
	connected_recheck="$(xrandr -q | grep " connected"|cut -d ' ' -f1|xargs)"

	# If original contents don't match new we need to run command.
	if [ "$connected" != "$connected_recheck" ]; then
		# Set the original contents the same as new to avoid unnecessarily repeating
		connected=$connected_recheck
		$command
	fi

	shift 1
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

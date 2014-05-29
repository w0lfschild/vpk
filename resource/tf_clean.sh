#!/bin/bash

hsc(){
    for f in "$1"/*; do
		if [ -d "$f" ]; then 
			hsc "$f" &
		elif [ -e "$f" ]; then
			if [[ "$f" = *.sound.cache ]]; then
				test="${f%.*}"
				test="${test%.*}"
				if [[ ! -e "$test" ]]; then
					rm -f "$f"
				else
					chflags -h hidden "$f"
				fi
			fi
			if [[ "$f" = *_[0-9][0-9][0-9].vpk ]]; then
				test="${f%_*}"_dir.vpk
				if [[ ! -e "$test" ]]; then
					echo no matching vpk found
					rm -f "$f"
				else
					chflags -h hidden "$f"
				fi
			fi
		fi
	done
}

tf2Dir=$(./tf_dir.sh)
hsc "$tf2Dir"


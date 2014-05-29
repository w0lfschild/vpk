#!/bin/bash

runScript() {
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:"$bindir"/
    if [ -d "$1" ]; then
        FILESIZE=$(du -s "$1" | cut -f 1)
        FILESIZE=$((FILESIZE * 1000 / 2))
        if [ $FILESIZE -gt 250000000 ]; then
            echo "Folder larger than 250mb, creating multi chunk vpk..."
            ./bin/vpk_osx32 -M "$1"
            echo "$1"_dir.vpk created
        else
            echo "Normal folder, creating vpk..."
            ./bin/vpk_osx32 "$1"
            echo "$1".vpk created
        fi
    else
        if [[ "$1" = *_[0-9][0-9][0-9].vpk ]]; then
            MODSTR2="${1%_*}"_dir.vpk
            if [ -e "$MODSTR2" ]; then
                echo "You input the wrong part of a multi chunk vpk but I have found the proper file and it will be extracted..."
                ./bin/vpk_osx32 "$MODSTR2"
                echo "$MODSTR2" extracted
            else    
                echo "You input the wrong part of a multi chunk vpk but no matching dir was found."
            fi 
        else
            echo normal vpk, extracting...
            ./bin/vpk_osx32 "$1"
            echo "$1" extracted
        fi
    fi
}

scriptdir=$(cd "${0%/*}" && echo $PWD)
bindir=$(dirname "${scriptdir}")
bindir="${bindir}/bin"
runScript "$1"

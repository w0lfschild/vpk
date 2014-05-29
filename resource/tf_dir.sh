#!/bin/bash

TF="Team Fortress 2"
BASEDIR=$(cd "${0%/*}" && echo $PWD)
TESTDIR=""
if [[ "${BASEDIR}" = *"${TF}"* ]]; then
	# vpk is inside TF2 Folder
	TESTDIR=${BASEDIR%%/${TF}*}/${TF}
else
	STEAMDIR="~/Library/Application Support/Steam/SteamApps"
    if [[ -L "$STEAMDIR" ]]; then
    	# Default SteamApps is a link to external SteamApps Folder
        TESTDIR=$(readlink "$STEAMDIR")
        TESTDIR="${TESTDIR}/common/${TF}"
    elif grep -q "Team Fortress 2" ~/Library/Application\ Support/Steam/config/config.vdf; then
        # TF2 install defined in config.vdf
        # use grep to grab line
        TESTDIR=$(grep "Team Fortress 2" ~/Library/Application\ Support/Steam/config/config.vdf)
		# wipe leading text installdir...
		TESTDIR="${TESTDIR//\"installdir\"/}"
		# remove quotes
		TESTDIR="${TESTDIR//\"/}"
		# wipe leading whitespace
		read -rd '' TESTDIR <<< "$TESTDIR"
	elif grep -q "BaseInstallFolder_1" ~/Library/Application\ Support/Steam/config/config.vdf; then
		# Steam Install folder defined in config.vdf
		# use grep to grab line
		TESTDIR=$(grep "BaseInstallFolder_1" ~/Library/Application\ Support/Steam/config/config.vdf)
		# wipe leading text BaseInstallFolder_1...
		TESTDIR="${TESTDIR//\"BaseInstallFolder_1\"/}"
		# remove quotes
		TESTDIR="${TESTDIR//\"/}"
		# append TF2 specific path
		TESTDIR="${TESTDIR}/SteamApps/common/${TF}" 
		# wipe leading whitespace
		read -rd '' TESTDIR <<< "$TESTDIR"
    else
    	# Dunno? So lets assume TF2 is in the base install path
        TESTDIR="${STEAMDIR}/common/${tf}"    
    fi 
fi
TF2DIR="$TESTDIR"
echo "$TF2DIR"
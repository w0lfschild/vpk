#!/bin/bash

# Run when an item has finished processing
# Takes process ID as input
item_complete() 
{
	# Increase progress percentage
	if [[ ITEMS -gt 0 ]]; then 
		PRGRS=$((PRGRS+100/$ITEMS))
	fi
	
	# Display completed item
	echo Completed ${procs["$1"]}
	
	# Smooth progress bar
	myitems=$((100/$ITEMS))
	for (( c=1; c<=$myitems; c++ )); do
		if [ $smooth_prgrs -gt $PRGRS ]; then 
			c=$myitems
		else
			echo "$smooth_prgrs Progress $smooth_prgrs%" >&3
			sleep .005
			((++smooth_prgrs))
		fi
	done	
}

# Process scanner that checks for when an item has finished
# Takes process list as input
wait_for_process() 
{
    local errors=0
    while :; do
        debug "Processes remaining: $*"
        for pid in "$@"; do
            shift
            if kill -0 "$pid" 2>/dev/null; then
                debug "$pid is still alive."
                set -- "$@" "$pid"
            elif wait "$pid"; then
                debug "$pid exited with zero exit status."
                item_complete "$pid"
            else
                debug "$pid exited with non-zero exit status."
                ((++errors))
            fi
        done
        (("$#" > 0)) || break
        sleep ${WAITALL_DELAY:-.1}
    done
    ((errors == 0))
}

debug() 
{ 
	echo "DEBUG: $*" >/dev/null
}

#
#
updch() 
{ 
	curver=$(cat ./version.txt)
	dlurl="http://sourceforge.net/projects/vpkosx/files/latest/download"
	verurl="http://sourceforge.net/projects/vpkosx/files/version.txt/download"
	if [[ $autoCheck == 1 ]]; then
		cur_date=$(date "+%y%m%d")
		if [[ $lastupdateCheck != $cur_date ]]; then
			defaults write ~/Library/Preferences/org.w0lf.vpk "lastupdateCheck" "${cur_date}"
			./updates/wUpdater.app/Contents/MacOS/wUpdater "c" "$APPDIR" "org.w0lf.vpk" $curver $verurl $dlurl $autoInstall &
		fi
	fi 
}

#
#	Main
#

# Paths
SCRDIR=$(cd "${0%/*}" && echo $PWD)
APPDIR=$(dirname "${SCRDIR}")
APPDIR=$(dirname "${APPDIR}")
COCOAD=./bin/CocoaDialog.app/Contents/MacOS/CocoaDialog
NOTIFY=./bin/notifier.app/Contents/MacOS/"vpk notifier"

# Misc
ITEMS="$#"
INSTALL_ACTIVE=false
PRGRS=0
smooth_prgrs=0
procs[0]=nothing

# Settings
# 0 - auto check for updates
# 1 - auto install updates
# 2 - last update check time
# 3 - version of last run
increment=0
for i in $(./settings.sh); do
	my_settings[$increment]=$i
	increment=$((increment + 1))
done
autoCheck=${my_settings[0]}
autoInstall=${my_settings[1]}
lastupdateCheck=${my_settings[2]}
lastVersion=${my_settings[3]}

# About fix script
CRFILE=$(more ./creditsCopy.html)
CRFILE=${CRFILE//"(insert_update_path)"/"${SCRDIR}"}
echo "${CRFILE}" > ./Credits.html

# First launch/updates only
curver=$(cat ./version.txt)
if [[ $lastVersion != $curver ]]; then 
	"${COCOAD}" textbox --float --width 600 --height 550 --title "Welcome" --text-from-file ./Readme.html --button1 "Okay" >/dev/null &
	defaults write ~/Library/Preferences/org.w0lf.vpk lastVersion $curver
fi

#"${COCOAD}" textbox --float --width 600 --height 550 --title "Welcome" --text-from-file ./Readme.html --button1 "Okay" >/dev/null &

# Main work here
if [[ $# -eq 0 ]]; then
	# No arguments so display that info to user and initiate update check
    echo -n "No arguments received"
    for i in {1..3}; do
    	echo -n "."
    	sleep .1
    done
    echo ""
    echo ""
    
    echo "Settings:"
    
    # Settings
	echo "   Automatic updates - $autoCheck"
	echo "   Automatic install - $autoInstall"
	echo "   Last Update Check - $lastupdateCheck"
	echo "   Last Launch Ver.  - $lastVersion"
	#echo "   ?"
	echo ""
	#
    
    # Run tf_clean to keep TF2 dir looking clean
    ./tf_clean.sh &
    ./logs.sh
else
	# Start update check in background (no output so it doesn't screw with other output)
	# updch &>/dev/null &
    
    # Set up logs
    ./logs.sh
    
    # Set up progress bar
    rm -f /tmp/hpipe
	mkfifo /tmp/hpipe
    "${COCOAD}" progressbar --float --title "vpk" --text "Starting conversion..." < /tmp/hpipe &
    exec 3<> /tmp/hpipe
	echo -n . >&3
	
	# Process all arguments with vpk output is piped to 1.log
    for f in "$@"; do
        ./vpk.sh "$f" >>./logs/1.log &
        pids="$pids $!"
        procs[$!]=${f##*/}
    done
    wait_for_process $pids
    
    # We're done here so move progress bar to 100% regardless of position
    echo "100 Progress 100%" >&3
    
    # Run tf_clean to keep TF2 dir looking clean
    ./tf_clean.sh &
    
    # Play completion ding
  	afplay -v 1 -q 1 ./ping.* > /dev/null &
    
    # Get message text ready
    OPENFOLDER=file://$(dirname "$1")
	OPENFILE=$(basename "$1")
	if [ $ITEMS -gt 1 ]; then
		MESSAGE="${OPENFILE} and $((ITEMS - 1)) other items"
	else
		MESSAGE="${OPENFILE}"
	fi
    
    # Remove progressbar
    exec 3>&-
    rm -f /tmp/hpipe
    
    # If display a notification
    if ($(if [[ $(sw_vers | grep tV) = *10.[8-9]* ]]; then echo true; fi)); then
		# Use Terminal Notifier to display a notification on OSX >= 10.8
		"${NOTIFY}" -title "Finished Processing:" -message "$MESSAGE" -open "$OPENFOLDER" > /dev/null
	else
		# Use CocoaDialog to display a notification on OSX < 10.8
		"${COCOAD}" bubble --timeout 5 \
		--alpha 1 \
		--title "Finished Processing:" \
		--text "$MESSAGE" \
		--icon-file "${SCRDIR}/icon.icns" \
		--border-color "B4B4B4" \
		--background-top "EDEDED" \
		--background-bottom "CCCCCC" >/dev/null &
	fi
fi

# Updater
updch

# Check if installer is running
number=$(ps -acx | grep wUpdater | wc -l)
if [[ $number -gt 0 ]]; then
	INSTALL_ACTIVE=true
fi

# If installer is active and waiting for vpk to close then quit without user prompt
if ($INSTALL_ACTIVE); then
	killall vpk
fi

#END
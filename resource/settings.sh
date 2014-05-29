create_setting()
{
	defaults write "${plist}" "$1" "$2"
	echo "$3"
}

# Get settings (also sets them up if it's the first run on an account)
settings_initialize()
{
	# About shortcut setup
	nullme=$(defaults read "${plist}" "NSUserKeyEquivalents" 2>/dev/null || defaults import "${plist}" "${SCRDIR}/keyboard.plist")
	
	# Settings
	settings_array=$(defaults read "${plist}" "autoCheck" 2>/dev/null || create_setting "autoCheck" 1 1)
	settings_array="${settings_array} "$(defaults read "${plist}" "autoInstall" 2>/dev/null || create_setting "autoInstall" 0 0)
	settings_array="${settings_array} "$(defaults read "${plist}" "lastupdateCheck" 2>/dev/null || create_setting "lastupdateCheck" 0 0)
	settings_array="${settings_array} "$(defaults read "${plist}" "lastVersion" 2>/dev/null || create_setting "lastVersion" 0 0)
	echo $settings_array
}

SCRDIR=$(cd "${0%/*}" && echo $PWD)
plist=~/Library/Preferences/org.w0lf.vpk
echo $(settings_initialize)


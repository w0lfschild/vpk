About:

Drop items onto the App Icon or Dock Icon or App Window, vpk will then process the items. You can also use the open menu if the app is running to select items and you should be able to set vpk as the default app to open .vpk files. Processed items are placed in the same folder as their parent.
	
Information:
	
Version -
	5.1

Build Date -
	May 30th 2014

(5.1)
What's New:
	- Improved updater
	
Fixed:
	- Updater bugs
	- General bug fixes	and code improvement

(5.0)	
What's New:
	- CocoaDialog 3.0-beta7
	- New about page
	- Ability to adjust basic settings in about page
	- Command+i > Shows about page
	- Notifications for systems lower than 10.8 (Mountain Lion)
	- Auto update checks run a max of once per day rather than each time the app is run
	- Auto installer (skips asking about install)
	- Changelog shown after updates
	- Amazingly sexy update download progress bar 
	
Fixed:
	- General bug fixes	and code improvement
	- Bugs with dialog if vpk was in a path that included spaces
	- Settings are saved between updates
	
Known Bugs:
	- None

Todo:
	- Additional settings
		- When adding vpk give option to either list content or extract
		- Option to merge vpks
		- Option to Extract/Insert via text strings
	- Re-envision and improve app updater
	
	
(4.0.2.1)
New or changed:
	- Notifications for systems lower than 10.8 (Mountain Lion)
	- Settings now saved in app and locally
	- Auto update checks run a max of once per day rather than each time the app is run
	- Auto installer (if auto updates are on)
	- Changelog shown after updates
	
Fixed:
	- Bugs with dialog if vpk was in a path that included spaces
	- Settings are saved between updates

(4.0)
New or changed:
	- Different display for main window
		- "Completed $item" output when a file finishes
		- You can now save the text output (command+s)
	
	- Uses CocoaDialog instead of osascripts to display dialogs
		- This will allow for notifications on older osx later)
		- New progress bar (basically just smoothed)
		- New update dialog allows keyboard input 
			Esc - Cancel 
			Enter - Install
		- First attempt at download/install progress bar for updater
	
	- Displays app info in separate window via CocoaDialog
		- Only displays app info on first open
		- Basic app info is now also located in about menu
	
	- Switched app to use alt icon (still need to switch vpk notifier)
	
	- Bug and typo fixes	
	
Bugs:
	- vpk notifier icon does not match app icon
	- No way to re-enable auto updates without using terminal 
		(only if you chose to never check for updates again)
	
Extra: 
	There are now two settings you can adjust via terminal
	
	To list the current settings enter:
	defaults read -app vpk 
	
	1 = Yes
	0 = No
	
	To edit either use:
	defaults write -app vpk "First Run" '1'
	defaults write -app vpk "Auto Update" '1'
		
(3.8.4)
	- Update dialogue uses vpk as parent instead of Finder
	- Suppressed ugly text output from ping and curl
	- Shortened ping timeout 
	- Altered version checking
	- If update is chosen vpk will close when idle
	- Notifications once again show as (vpk notifier) rather than (_)
	- Removed unnecessary Valve dylib (saved ~1.4MB)
	- Moved first run test from update to main thread
	
(3.8.3.1)
	- Fixed auto updater failing to move updated app
	
(3.8.3) 
	- Updated vpk tools from Valve (reduced size ~1.2 MB)
	- New format for version specific readme files
	- New auto updater

(3.8.2)
	- Updated readme to match version
	
(3.8.1)
	- Notifications now use vpk icon and show under "vpk notifier"
	- Bumped terminal notifier to 1.5.1

(3.8)
	- Bumped terminal notifier to 1.5.0
	
(3.7) 
	- User modifiable completion sound ./vpk.app/Contents/Resources/sound/ping.aiff
	- Simply name ping.aiff to ping_old.aiff and grab another audio sample you want to use, name it ping (leave the extension alone) and place it with the old sound or rename ping.aiff to ping_old.aiff to hear no completion ding 
	- Lowered ping volume
	- Increased ping sound quality
	- New default ping sound
	- README has slightly better formatting in-app
	- Fixed a few minor Bugs
	
(3.6)
	- Clicking on a notification now shows the first item in finder 
	- Fixed notification text not displaying full name of items with white space
	
(3.5)	 
	- Improved logging function
 	- New notification layout
	- Cleaned unused files
	
(3.4) 
	- Displays Notifications on OSX 10.8+
	- lib_sys used to check OSX version for notifications
	- lib_hsc now uses sub processess
	- lib_tfdir now uses ~/Library/Application\ Support/Steam/config/config.vdf
	- vpk can find your TF2 directory if it is outside the standard install 
			 
(3.3) 
	- Runs without TF2 and/or Steam installed
	- Only displays progress in text box
	- Logs the last 5 runs in vpk.app/Contents/Resources/log/*
	- Sleeps for 1 second after completing a group of items

	Fixed:	 
	- Processing multiple items not running simultaneously
	- Progress bar not reaching 100% for multiple items
	- Progress bar displaying 100% multiple times
	- Not being able to drop folders on icon
	- Improper text output on a few scenarios

(3.0)
	- Process multiple vpk/folder at one time.
	- Plays ding sound when all processes complete.
	- Progress bar updates to match progress (somewhat).

(2.0)
	- If a directory is over 250MB a multi chunk vpk will be made. 
	- Automatically find correct vpk dir file if part is given. 
	- Hides all .sound.cache files in your Team Fortress 2 directory. 
	- Can be set as the default application to open vpk files.
	- App icon and File icon for vpks.

(1.0)
	- Runs vpk_osx32 taking dropped items as input

Credits:

Icon from:			
http://blog.cocoia.com/2010/redesigning-steam-for-mac/

Built with:		
http://sveinbjorn.org/platypus

Notifications via:
http://github.com/alloy/terminal-notifier

Installer trash script:
http://hasseg.org/trash
	
CocoaDialog:
http://mstratman.github.io/cocoadialog/#	
	
Contact:
http://www.steamcommunity.com/id/w0lfschild
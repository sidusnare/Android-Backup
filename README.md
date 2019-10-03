# Android-Backup
Backup script that uses ADB to backup a phone

## Use
This is meant to backup a phone to a Linux workstation with adb and then push it to a file server via rsync.

## Caveats
Sometimes adb pull /sdcard fails and is uses tar instead.
This is just backing up /sdcard, so it will work on locked non-rooted phones, but won't get "everything"
Read it before you use it, set the paramaters to suit your use case.
No waranties or gurandees, this could erase all your data and insult your grandmother.

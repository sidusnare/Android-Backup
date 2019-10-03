#!/usr/bin/env bash

filterlist=( 'sdcard/Android/data/com.audible.application' 'sdcard/Android/data/com.reddit.frontpage/cache' 'sdcard/Android/data/com.google.android.youtube/cache' )
server="server.domain.com"
base="/Data/Backups/phone/"
user="${USER}"

serial='XXXXXXXXX'
if [ ! -d "${HOME}/Stuff/${serial}" ]; then
	mkdir -p "${HOME}/Stuff/${serial}"
fi
cd "${HOME}/Stuff/${serial}" || exit 1
if [ -e "sdcard" ]; then
	rm -rf "sdcard"
fi
if ! adb -s "${serial}" shell true; then
	echo "Unable to find ${serial} / ${serial}"
	exit 1
fi
echo "Backing up ${serial} to ${HOME}/Stuff/${serial}, then to ${user}@${server}:${base}/${serial}/"
df -h .
adb -s "${serial}" shell df -h  /sdcard
filterreg="$( printf "%s|" "${filterlist[@]}" | sed 's/|$//' )"

if ! adb -s "${serial}" pull -a /sdcard; then
	adb -s "${serial}" shell find /sdcard/ -type f -print | \
	grep -E -v "${filterreg}" | \
	sed -e 's/^/"/g' -e 's/$/"/g' | \
	tr '\n' '\0' | \
	xargs -n 20 -0 adb_tar_cp.sh "${serial}"
fi
for f in "${filterlist[@]}";do
	rm -rf "${f}"
done
rsync -HAXhaxvPS ./sdcard/ "${user}@${server}:${base}/${serial}/"

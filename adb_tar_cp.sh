#!/usr/bin/env bash

serial="${1}"
shift
if ! adb -s "${serial}" shell true; then
	echo "Error connecting to device, first arg must be serial"
	exit 1
fi

#echo -- "copying ${*}"
files=()
for file in "${@}";do
	if [ -e "${file}" ]; then
		continue
	fi
	files+=( "${file}" )
done
if ! [ "${#files[@]}" -gt 0 ]; then
	exit 0
fi
adb -s "${serial}" shell tar -c -- "${files[@]}" | tar -xv
echo "done ${$}"
exit 0

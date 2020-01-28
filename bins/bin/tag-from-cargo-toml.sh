#!/bin/bash

dry=0
if [[ $# -eq 1 && $1 == "-n" ]]; then
	dry=1
	shift
fi

was=""
for hash in $(git log --first-parent --format=oneline Cargo.toml | awk '{print $1}'); do
	v=$(git show "$hash:Cargo.toml" | grep -P '^version\s*=' | head -n1 | sed -e 's/[^"]*"//' -e 's/".*//')
	[[ $was != $v ]] || continue;
	if [[ $was = ${v}-* ]]; then
		# pushed an alpha/beta/rc *after* main version?
		# no, main version cannot have been released as non-alpha first
		continue
	fi
	was=$v
	if git rev-parse v$v > /dev/null 2>&1; then
		echo "$hash v$v (already tagged)"
		continue
	fi
	if [[ $dry -eq 0 ]]; then
		git tag -as -m "Release v$v" "v$v" "$hash"
	fi
	echo "$hash v$v"
done

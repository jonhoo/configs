#!/bin/bash

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
	git tag -as -m {"Release ",}"v$v" "$hash"
	echo "$hash v$v"
done

#!/bin/bash

dry=0
if [[ $# -gt 0 && $1 == "-n" ]]; then
	dry=1
	shift
fi
prefix="v"
if [[ $# -gt 0 ]]; then
	if [[ $1 = -* || $# -gt 1 ]]; then
		echo "Usage: $0 [-n] [prefix]"
		exit 1
	fi
	prefix="$1"
	shift
fi

function tag() {
	local v=$1
	local hash=$2
	local tag="${prefix}${v}"
	if git rev-parse "$tag" > /dev/null 2>&1; then
		existing=$(git rev-parse "$tag^{}")
		if [[ $hash == $existing ]]; then
			echo "$hash $tag (already tagged)"
		else
			echo "$hash $tag (already tagged at $existing)"
		fi
		return
	fi
	if [[ $dry -eq 0 ]]; then
		git tag -as -m "Release $tag" "$tag" "$hash"
	fi
	echo "$hash $tag"
}

# in case we're in a subdir:
cargo_toml=$(git ls-files --full-name Cargo.toml)
was=""
last_hash=""
for hash in $(git log --first-parent --format=oneline Cargo.toml | awk '{print $1}'); do
	v=$(git show "$hash:$cargo_toml" | grep -P '^version\s*=' | head -n1 | sed -e 's/[^"]*"//' -e 's/".*//')
	if [[ $was == $v ]]; then
		# same version -- keep walking until we hit the previous
		last_hash=$hash
		continue
	fi
	if [[ $was = ${v}-* ]]; then
		# pushed an alpha/beta/rc *after* main version?
		# no, main version cannot have been released as non-alpha first
		continue
	fi
	if [[ -z "$was" ]]; then
		# start search
		was="$v"
		last_hash="$hash"
		continue
	fi

	# this hash has a different hash than the previous one. so tag the last
	# hash with the last version number, since that was the first hash at
	# which that version number appeared.
	tag "$was" "$last_hash"
	last_hash="$hash"
	was=$v
done

# tag the first commit that has this Cargo.toml
tag "$was" "$last_hash"

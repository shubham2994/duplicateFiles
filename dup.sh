#!/bin/bash
## check input dirs both exist
[ -e "$1" ] && [ -e "$2" ] || {
printf "\nError: invalid path. Usage %s dirA pathB\n\n" "${0##*/}"
exit 1
}
tmp="tmp_$(date +%s).txt"
[ -f "$tmp" ] && rm "$tmp"
find "$2" -type f > "$tmp"
# unique temp file name
# test if already exists and del
# fill tmp file with possible dups
for i in $(find "$1" -type f); do
# check each file in A ($1) against tmp
fn="${i##*/}"
# remove path from A/filename
if grep -q "$fn" "$tmp"; then
# test if A/file found in pathB ($2)
if [ "$3" = -d ]; then
# if 3rd arg is '-d', really delete
for rmfn in $(grep "$fn" "$tmp"); do
# get list of matching filenames
printf " deleting: %s\n" "$rmfn" >&2 # print record of file deleted
rm "$rmfn"
# the delete command (commented)
done
else
# if no '-d', just print duplicates found
printf "\n Duplicate(s) found for: %s\n\n" "$fn"
grep "$fn" "$tmp"
# output duplicate files found
fi
fi
done
rm "$tmp"
# delete tmp file
exit 0

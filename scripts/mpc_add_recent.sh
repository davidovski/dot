#!/bin/sh
# add recently added files to the playlist

count=${1:-10}

cd ~/music
find . -type f -print0 | xargs -0 stat -c"%Y %n" | sort -n | tail -${count} |cut -d' ' -f2- | while read -r line; do printf "%s\n" "$line" ; mpc insert "${line#./}"; done

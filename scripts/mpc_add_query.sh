#!/bin/sh

query=${1}
cd ~/music
find . -iname "*$query*" -type f | while read -r line; do echo "$line"; mpc insert "${line#./}"; done

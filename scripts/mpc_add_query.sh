#!/bin/sh

query=${1}
mpc -f "%title%[\t\t%artist%][\t\t%album%]\t\t%file%" listall | grep -i "${query}" | rev | cut -f1 -d'	' | rev | while read -r track; do
    echo "$track"
    mpc insert "$track"
done

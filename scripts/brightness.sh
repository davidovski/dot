#!/bin/sh
t=1s

# takes number from 0-100 and uses it for brightness, with transition,  will save 

command -v slight >/dev/null || echo "INSTALL SLIGHT: cargo install slight"

if [ "$1" = "save" ]; then
    for d in /sys/class/backlight/*; do
        echo $d
        slight get -D $d > /tmp/brightness-$(basename $d)
    done
    exit 0
fi

if [ "$1" = "restore" ]; then
    pkill slight
    for d in /sys/class/backlight/*; do
        echo $d
        slight set -D $d -t $t $(cat /tmp/brightness-$(basename $d))
    done
    exit 0
fi

for d in /sys/class/backlight/*; do
    echo $d
    slight -D $d set $@ &
done



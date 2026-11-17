#!/bin/sh
t=1s

# takes number from 0-100 and uses it for brightness, with transition,  will save 

command -v slight >/dev/null || echo "INSTALL SLIGHT: cargo install slight"

if [ "$1" = "save" ]; then
    for d in /sys/class/backlight/*; do
        echo saving $d
        slight -D $d get > /tmp/brightness-$(basename $d)
    done
    exit 0
fi

if [ "$1" = "restore" ]; then
    pkill slight
    for d in /sys/class/backlight/*; do
        echo restoring $d
        slight -D $d set $(cat /tmp/brightness-$(basename $d)) &
    done
    wait
    exit 0
fi

for d in /sys/class/backlight/*; do
    echo setting $d
    slight -D $d set $@ &
done

wait


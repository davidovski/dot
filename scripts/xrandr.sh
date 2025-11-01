#!/bin/sh
all=$(xrandr | grep "connected" | cut -d' ' -f1 | paste -s -d' ')
available=$(xrandr | grep " connected" | cut -d' ' -f1 | paste -s -d' ')
set -- $available

printf "connected: "
printf "%s " $available
printf "\n"

printf "all: "
printf "%s " $all
printf "\n"

if [ "$1" == "eDP1" ]; then
    # this is a laptop so awesome!

    if [ "$#" != "1" ]; then
        # ensure the main one is turned on yeah
        xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal

        # put the non main one to the left (assume its +1920 because im lazy)
        xrandr --output "$2" --primary --mode 2560x1440 --pos 1920x0 --rotate normal
    else
        # ensure the main one is turned on yeah
        xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
    fi
    #disconnect all the rest i think
    for x in $all; do
        echo disconnecting $x
        case $available in
            *"$x"*) ;;
            *) xrandr --output "$x" --off
        esac
    done
fi

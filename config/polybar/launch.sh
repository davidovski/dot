#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar, using default config location ~/.config/polybar/config
#polybar music &

#MONITOR=DP-0 polybar --reload  wsonly &

polybar -m | while read -r mon; do
    export MONITOR=$(echo $mon | cut -d: -f1)
    width="$(echo $mon | cut -d' ' -f2 | cut -dx -f1)"
    w=1920
    case "$width" in
        1920) w=1920
            ;;
        1080) w=1080
            ;;
        2560) w=2560
            ;;
        *) w=1920
    esac

    echo $mon | grep -q "(primary)" && {
        polybar ws &

        polybar time$w &
        polybar right$w &
        polybar mpd$w &
    } || {
        polybar ws &
        polybar time$w &
    }
done

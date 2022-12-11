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
    echo $mon | grep -q "(primary)" && {
        polybar ws &
    } || {
        polybar wsonly &
    }
done

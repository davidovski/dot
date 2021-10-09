#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

# Launch Polybar, using default config location ~/.config/polybar/config
#polybar music &

#MONITOR=DP-0 polybar --reload  wsonly &

export MONITOR=DP-1
polybar wsonly &

export MONITOR=DP-4
polybar wsonly &

export MONITOR=HDMI-0
polybar wsonly &

export MONITOR=DP-2
polybar ws &

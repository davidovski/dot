#!/bin/sh
winid=$(xdotool search "Mine" | head -n1)
for i in {1..50};
	do
	xdotool keydown "5"
	xdotool keyup "5"
    sleep 0.05
done
exit 0

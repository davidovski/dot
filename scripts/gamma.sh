#!/bin/bash
MAIN_DP=eDP1;  

v=$1

if [ $# -ne 0 ]; then
	xrandr --output $MAIN_DP --gamma $(paste -d" " <(xrandr | grep " connected" | cut -f1 -d " ") <(xrandr --current --verbose | grep "Gamma" | cut -f7 -d" " | cut -f1 -d":" | xargs -I % echo "1/%") | grep $MAIN_DP | cut -d" " -f2 | xargs -I % echo "%*$v" | bc -l)
else
	xrandr --output $MAIN_DP --gamma 1
fi

#!/bin/sh
MAIN_DP=DP-1;  
v=$(xrandr --current --verbose | grep "Brightness" | cut -f2 -d " " | tr '\n' '*' | rev | cut -c 2- | rev | sed -e "s/$/==1/" | bc -l | grep -q 0 && echo 1 || echo 0); xrandr | grep " connected" | cut -f1 -d " " | while read -r line; do echo $line | grep -q $MAIN_DP && : || xrandr --output $line --brightness $v; done

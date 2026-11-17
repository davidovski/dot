#!/bin/sh
# change brightnesss of all displays

arg="${1:-100}"

for display in $(ddcutil detect | grep Display | cut -f2 -d' '); do
    ddcutil --display $display setvcp 10 "$arg" &
done

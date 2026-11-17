#!/bin/sh
amixer set Capture toggle

# send signal to waybar to update
pkill -RTMIN+12 waybar

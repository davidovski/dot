#!/bin/sh
xrandr | awk '/ primary / {print $1}'


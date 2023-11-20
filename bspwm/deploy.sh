#!/bin/sh

wd="$HOME/.local/src/bspwm"

[ ! -d "$HOME/.local/src" ] && mkdir -p "$wd"

rm -rf "$wd"
git clone https://github.com/baskerville/bspwm "$wd"

patch -d "$wd" -p1 -i $(realpath change_update_order.patch)

make -C "$wd" 
doas make -C "$wd" install PREFIX=/usr

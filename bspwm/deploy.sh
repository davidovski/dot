#!/bin/sh

wd="$HOME/.local/src/bspwm"

[ ! -d "$HOME/.local/src" ] && mkdir -p "$wd"

rm -rf "$wd"
git clone https://github.com/phuhl/bspwm-rounded "$wd"
git -C "$wd" checkout 8b6e8f065d5667728f4f58c06f4f65f790c04a66

patch -d "$wd" -p1 -i $(realpath 01-fix-polybar-rounding.patch)

make -C "$wd" 
doas make -C "$wd" install PREFIX=/usr

#!/bin/sh

wd="$HOME/.local/src/st"

[ ! -d "$HOME/.local/src" ] && mkdir -p "$wd"

rm -rf "$wd"
git clone https://git.suckless.org/st "$wd"

patch -d "$wd" -p1 -i $(realpath davidovski.patch)

make -C "$wd" 
doas make -C "$wd" install PREFIX=/usr

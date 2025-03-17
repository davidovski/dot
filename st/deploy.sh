#!/bin/sh

wd="$HOME/.local/src/st"

[ ! -d "$HOME/.local/src" ] && mkdir -p "$wd"

rm -rf "$wd"
git clone https://git.suckless.org/st "$wd"
git -C "$wd" checkout 9846a56bd7fdc86bf788db04bbbcbde7b7eb9952

patch -d "$wd" -p1 -i $(realpath davidovski.patch)

make -C "$wd" 
doas make -C "$wd" install PREFIX=/usr

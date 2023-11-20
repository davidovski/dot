#!/bin/sh

wd="$HOME/.local/src/compfy"

[ ! -d "$HOME/.local/src" ] && mkdir -p "$wd"

rm -rf "$wd"
git clone https://github.com/allusive-dev/compfy "$wd"

patch -d "$wd" -p1 -i $(realpath uncomment_sliding_animation.patch)

cd "$wd"
meson build && meson compile -C build && doas meson install -C build
cd -

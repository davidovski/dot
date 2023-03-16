#!/bin/sh

pkgver=1.5

[ -d "~/.local/src" ]mkdir -p ~/.local/src

curl -o ~/.local/src/slock-$pkgver.tar.gz https://dl.suckless.org/tools/slock-$pkgver.tar.gz 
tar -C ~/.local/src/ -xvf ~/local/src/slock-$pkgver.tar.gz

srcdir=~/.local/src/slock-$pkgver
    cp config.h $srcdir
make -C $srcdir

doas make -C $srcdir install PREFIX=/usr

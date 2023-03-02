#!/bin/sh
file="$(fzf $@)"
xdg-open $file &

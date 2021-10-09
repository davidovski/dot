#!/bin/sh
bspc config honor_size_hints | grep -q true && bspc config honor_size_hints false || bspc config honor_size_hints true


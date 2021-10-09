#!/bin/sh
GAP=16; bspc config window_gap | grep -q $GAP && bspc config window_gap 0 || bspc config window_gap $GAP


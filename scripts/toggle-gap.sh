#!/bin/sh
GAP=40; bspc config window_gap | grep -q $GAP && bspc config window_gap 0 || bspc config window_gap $GAP


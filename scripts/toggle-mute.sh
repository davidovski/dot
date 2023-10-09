#!/bin/sh
#
pactl list sources | grep -qi 'Mute: yes' && pactl set-source-mute 0 false || pactl set-source-mute 0 true


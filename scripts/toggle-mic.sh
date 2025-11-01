#!/bin/sh
SOURCE=1
pactl list sources | grep -qi 'Mute: yes' && pactl set-source-mute $SOURCE false || pactl set-source-mute $SOURCE true


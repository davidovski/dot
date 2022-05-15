#!/bin/sh
info=/tmp/wminfo

xwininfo > /tmp/wminfo

geom=$(cat $info | grep "geometry" | cut -d' ' -f4) 

width=$(cat $info | grep Width | cut -d' ' -f4)
height=$(cat $info | grep Height | cut -d' ' -f4)

size="${width}x${height}"
position=+$(echo $geom | cut -d'+' -f2- | sed "s/+/,/g")

filename=$(date +"$HOME/pics/screenshot/%F_%T.mp4")

echo $size and $position
ffmpeg -y -f x11grab -video_size $size -i $position $filename

rm $info

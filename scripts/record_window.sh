#!/bin/sh
info=/tmp/wminfo

xwininfo > /tmp/wminfo

geom=$(cat $info | grep "geometry" | cut -d' ' -f4) 

width=$(cat $info | grep Width | cut -d' ' -f4)
height=$(cat $info | grep Height | cut -d' ' -f4)

size="${width}x${height}"
x=$(cat $info | grep "Absolute upper-left X" | cut -d' ' -f7)
y=$(cat $info | grep "Absolute upper-left Y" | cut -d' ' -f7)
position="+$x,$y"

filename=$(date +"%F_%T.mp4")

echo $size and $position
ffmpeg -y -f x11grab -video_size $size -i "$position" $filename

rm $info

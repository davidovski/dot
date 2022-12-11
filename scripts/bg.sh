#!/bin/sh
setbg="feh --force-aliasing --bg-tile "

image=~/.config/bg.gif
dir=/tmp/bggif  

printf "Converting..."
[ ! -d "$dir" ] || rm -rf "$dir"
mkdir -p "$dir"

convert -coalesce $image $dir/%05d.png
printf "done\n"

amount_of_frames=$(ls -1 "$dir" | wc -l)
frames_per_second=30
speed=$(echo "scale=3; ($amount_of_frames/$frames_per_second) * (1/$frames_per_second)" | bc -l)

while : ; do 
    for i in $(ls -1 $dir); do
        $setbg $dir/$i;
        sleep $speed
    done;
done    

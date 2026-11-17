#!/bin/sh
set +v
#MAIN_DP=$($HOME/.scripts/primary-display.sh);  
#v=$(xrandr --current --verbose | grep "Brightness" | cut -f2 -d " " | tr '\n' '*' | rev | cut -c 2- | rev | sed -e "s/$/==1/" | bc -l | grep -q 0 && echo 1 || echo 0); xrandr | grep " connected" | cut -f1 -d " " | while read -r line; do echo $line | grep -q $MAIN_DP && : || xrandr --output $line --brightness $v; done


# waiiit lets use ddc 
# there is a funny thing where
# wher euhhh
# ddc D6 lets you set monitors to off!?
# and the two monitors i have on the sides are really good because they dont o
#
# ok so lemme over engineer this thingie yipee


# how fast to transition to black for the mpv
TRANSITION_LEVEL=250

# file, if exists, then the monitors need to be turned off
STATUS_FILE=/tmp/cinema_state

# vcp code for power
#
POWER_MODE=D6

# i2c bus numbers for the monitors we want to control
#
monitors="5 17"

# irl names of those monitors
#
monitors_wl="HDMI-A-3 HDMI-A-4"

OFF="x04"
ON="x01"

# get the state of a monitor
#
#  get_state bus
#
get_state () {
    ddcutil --bus=$1 getvcp $POWER_MODE --terse |
        awk '$1 == "VCP" && $2 == "D6" { print $4 }'
}

# set the state of a monitor
#
#  set_state bus state
#
set_state () {
    ddcutil --disable-cross-instance-locks --bus=$1 setvcp $POWER_MODE $2
}


is_off () {
    # if we have the status file, use that
    if [ -f "$STATUS_FILE" ]; then

        # read status from the file
        case "$(cat $STATUS_FILE)" in
            "$OFF") return 0 ;;
            "$ON") return 1 ;;
        esac
    fi

    # otherwise we will use the actual states or smth:
    # if either is off, then its off
    for m in $monitors; do
        if [ "$(get_state $m)" = "$OFF" ]; then
            return 0;
        fi
    done

    return 1;
}

# ok this is silly but we spawn mpv over the top to make the screen black before we turn it off so its a bit smoother
# 
#  spawn_mpv screen (idk what the screen numbers are , but its 0-2 for me, with 1 and 2 being left and righ)
#
spawn_mpv () {
    mpv \
      'av://lavfi:color=c=black:s=1920x1080:r=1' \
      --no-audio \
      --loop-file=inf \
      --fullscreen \
      --fs-screen=$1 \
      --no-osc \
      --osd-level=0 \
      --no-input-default-bindings \
      --no-terminal \
      --title=monitor-blackout
}

toset=$(is_off && echo $ON || echo $OFF)

if [ "$toset" = "$ON" ]; then
    niri  msg action do-screen-transition --delay-ms $TRANSITION_LEVEL
    pkill -f 'mpv.*monitor-blackout'
else
    niri  msg action do-screen-transition --delay-ms $TRANSITION_LEVEL
    spawn_mpv 2 &
    spawn_mpv 1 &
fi

for m in $monitors; do
    set_state $m $toset
done

echo $toset > $STATUS_FILE
wait

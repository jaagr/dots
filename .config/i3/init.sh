#!/usr/bin/env bash
#
# Launches i3
#

timestamp=$(date +'%Y-%m-%d %H:%M:%S')

echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/i3/stdout"
echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/i3/stderr"

"$LOCAL_ETC/sxhkd/init.sh" "$LOCAL_ETC/sxhkd/sxhkdrc.i3" &
"$LOCAL_ETC/compton/init.sh" &

sleep 1

lemonbuddy_wrapper i3 -c examples/config.i3.edp1 &
lemonbuddy_wrapper i3 -c examples/config.i3.hdmi1 &
echo Bar runners are up...

# TODO: Implement bspwm-looping
/usr/bin/i3 > "$XDG_CACHE_HOME/i3/stdout" 2> "$XDG_CACHE_HOME/i3/stderr"

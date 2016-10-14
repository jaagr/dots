#!/usr/bin/env bash
#
# Launches i3
#

timestamp=$(date +'%Y-%m-%d %H:%M:%S')

echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/i3/stdout"
echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/i3/stderr"

# TODO: Implement bspwm-looping
exec /usr/bin/i3 > "$XDG_CACHE_HOME/i3/stdout" 2> "$XDG_CACHE_HOME/i3/stderr"

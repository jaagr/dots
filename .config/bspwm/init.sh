#!/usr/bin/env bash
#
# Launches bspwm
#

# Append timestamp to both logs
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/bspwm/stdout"
echo -e "---- STARTUP $timestamp ----" >> "$XDG_CACHE_HOME/bspwm/stderr"

run_count=0

while true; do
  run_count=$((run_count+1))
  export BSPWM_COUNTER=$run_count
  bspwm > "$XDG_CACHE_HOME/bspwm/stdout" 2> "$XDG_CACHE_HOME/bspwm/stderr" || break
  killall -q bspc
done

# Kill off any children
ps x | egrep "(bspwmrc|lemonbar|lemonbuddy)" | awk '!/grep/ {print $1}' | xargs kill

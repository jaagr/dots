#!/usr/bin/env bash

declare -a wnames=()

wnames+=(polybar-top_eDP-1)

function move_windows
{
  local -i y=$1
  local -i c=$1

  (( c < 0 )) && c=${c:1}

  for i in $(seq 1 $((c/2))); do
    for wid in $(xdo id -a polybar-top_eDP-1) $(xdo id -n xdrawrect); do
      if (( y < 0 )); then
        wmv 0 -2 "$wid"
      else
        wmv 0 2 "$wid"
      fi
    done
  done
}

function main
{
  if [[ "$1" == "setup" ]]; then
    move_windows -24
    xdotool search --name polybar-top_eDP-1 behave %@ mouse-enter exec --sync "$XDG_CONFIG_HOME"/polybar/autohide show &
    xdotool search --name polybar-top_eDP-1 behave %@ mouse-leave exec --sync "$XDG_CONFIG_HOME"/polybar/autohide hide &

  elif [[ "$1" == "show" ]]; then
    if [[ $(wattr y "$(xdo id -a polybar-top_eDP-1)") -eq 1281 ]]; then
      move_windows 24
    fi
  elif [[ "$1" == "hide" ]]; then
    sleep 1

    eval "$(xdotool getmouselocation --shell)"

    xdotool getwindowname "$WINDOW" 2>/dev/null | egrep '(polybar|xdrawrect)' || {
      if [[ $(wattr y "$(xdo id -a polybar-top_eDP-1)") -eq 1305 ]]; then
        move_windows -24
      fi
    }
  fi
}

main "$@"

#!/usr/bin/env bash

ln -fs "$(i3 --get-socketpath)" "$XDG_CONFIG_HOME/i3/socket"

killall -q lemonbuddy lemonbar xdrawrect

[[ -e "$CURRENT_THEME/i3" ]] && {
  source "$CURRENT_THEME/i3"
}

if [[ -n "$(type theme::pre_startup 2>/dev/null)" ]]; then
  theme::pre_startup 2>/dev/null & sleep 1
fi

if [ -s "$HOME/.fehbg" ]; then
  source "$HOME/.fehbg" 2>/dev/null
elif [ -e "$HOME/.wallpapers/1.png" ]; then
  feh --bg-center --image-bg -B black "$HOME/.wallpapers/1.png"
fi

[[ "$size_gap" ]] && i3-msg gaps outer all set "$size_gap"
[[ "$size_border" ]] && i3-msg border pixel "$size_border"

"${XDG_CONFIG_HOME}"/lemonbuddy/launch.sh --kill-all \
  "${lemonbuddy_config:-${XDG_CONFIG_HOME}/lemonbuddy/i3.conf}" \
  "${lemonbuddy_bars[*]}"

if [[ -n "$(type theme::post_startup 2>/dev/null)" ]]; then
  theme::post_startup 2>/dev/null &
fi

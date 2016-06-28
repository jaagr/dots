#!/usr/bin/env bash

killall -q lemonbuddy lemonbar xdrawrect

sleep 1

[[ -e "$CURRENT_THEME/i3" ]] && {
  source "$CURRENT_THEME/i3"
}

if [[ -n "$(type theme::pre_startup 2>/dev/null)" ]]; then
  theme::pre_startup 2>/dev/null & sleep 1
fi

[[ "$size_gap" ]] && i3-msg gaps outer all set "$size_gap"
[[ "$size_border" ]] && i3-msg border pixel "$size_border"

for bar in "${lemonbuddy_bars[@]}"; do
  echo "Using lemonbuddy config: $config"

  if lemonbuddy -h | grep -q "pipe=FILE"; then
    lemonbuddy_wrapper "$bar" -c "$lemonbuddy_config" &
  else
    lemonbuddy "$bar" -c "$lemonbuddy_config" &
  fi
done

ln -fs "$(i3 --get-socketpath)" "$XDG_CONFIG_HOME/i3/socket"

if [[ -n "$(type theme::post_startup 2>/dev/null)" ]]; then
  theme::post_startup 2>/dev/null &
fi

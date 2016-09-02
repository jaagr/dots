#!/usr/bin/env bash

source bootstrap.sh

include utils/x11.sh

bootstrap::finish

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

config="${lemonbuddy_config:-${LOCAL_ETC}/lemonbuddy/i3.conf}"

for bar in "${lemonbuddy_bars[@]}"; do
  echo "Using lemonbuddy config: $config"

  monitor="$(lemonbuddy "$bar" -c "$config" --dump=monitor)"

  if ! x11::monitor_connected "$monitor"; then
    echo "Skipping lemonbuddy bar '$bar' for disconnected monitor '$monitor'" >&2; continue
  fi

  bar_wmname=$(lemonbuddy "$bar" -c "$config" --print-wmname)

  if [[ -z "$bar_wmname" ]]; then
    echo "Could not get Lemonbuddy WM_NAME for bar '$bar', skipping..." >&2; continue
  fi

  if lemonbuddy -h | grep -q "pipe=FILE"; then
    lemonbuddy_wrapper "$bar" -c "$config" &
  else
    lemonbuddy "$bar" -c "$config" &
  fi

  if lemonbuddy -h | grep -q "restack"; then
    continue
  fi

  retries=0

  while (( retries++ < 10 )); do
    root_id=$(x11::wmname_wid "[i3 con] output $monitor")
    bar_id=$(x11::wmname_wid "$bar_wmname")

    if [[ "$root_id" ]] && [[ "$bar_id" ]]; then
      xdo above -t "$root_id" "$bar_id"
      break
    else
      printf "Failed to restack lemonbuddy window (root=%s bar=%s)... retrying in 1s\n" "$root_id" "$bar_id" >&2
      sleep 1
    fi
  done
done

ln -fs "$(i3 --get-socketpath)" "$XDG_CONFIG_HOME/i3/socket"

if [[ -n "$(type theme::post_startup 2>/dev/null)" ]]; then
  theme::post_startup 2>/dev/null &
fi

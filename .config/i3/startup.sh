#!/usr/bin/env bash

source bootstrap.sh

include utils/x11.sh

bootstrap::finish

function main
{
  killall -q lemonbuddy lemonbar xdrawrect
  ln -fs "$(i3 --get-socketpath)" "${XDG_CONFIG_HOME}/i3/socket"

  [[ -e ${CURRENT_THEME}/i3 ]] && source "${CURRENT_THEME}/i3"

  declare -f theme::pre_startup >/dev/null && theme::pre_startup

  [[ "$size_gap" ]] && i3-msg gaps outer all set "$size_gap"
  [[ "$size_border" ]] && i3-msg border pixel "$size_border"

  "${XDG_CONFIG_HOME}/lemonbuddy/launch" --kill-all \
    "${lemonbuddy_config:-${XDG_CONFIG_HOME}/lemonbuddy/config.i3}" \
    "${lemonbuddy_bars[*]}"

  declare -f theme::post_startup >/dev/null && theme::post_startup
}

main "$@"

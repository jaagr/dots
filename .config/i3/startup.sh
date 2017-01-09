#!/usr/bin/env bash

source bootstrap.sh

include utils/x11.sh

bootstrap::finish

function main
{
  ln -fs "$(i3 --get-socketpath)" "${XDG_CONFIG_HOME}/i3/socket"

  [[ -e ${CURRENT_THEME}/i3 ]] && source "${CURRENT_THEME}/i3"

  declare -f theme::pre_startup >/dev/null && theme::pre_startup

  [[ "$size_gap" ]] && i3-msg gaps outer all set "$size_gap"
  [[ "$size_border" ]] && i3-msg border pixel "$size_border"

  killall polybar
  polybar example -r &
  # "${XDG_CONFIG_HOME}/polybar/launch" --kill-all \
  #   "${polybar_config:-${XDG_CONFIG_HOME}/polybar/config.i3}" \
  #   "${polybar_bars[*]}"

  declare -f theme::post_startup >/dev/null && theme::post_startup
}

main "$@"

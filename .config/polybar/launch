#!/usr/bin/env bash

source bootstrap.sh

include utils/log.sh
include utils/x11.sh

bootstrap::finish

function main
{
  if [[ $# -lt 2 ]]; then
    log::err "Usage: $0 [-k|--kill-all] <config> <bar_name> [bar_name...]"; exit 1
  fi

  if [[ "$1" == "-k" ]] || [[ "$1" == "--kill-all" ]]; then
    killall -q polybar &>/dev/null ; shift
    local i=0;
    while (( ++i < 5 )) && pgrep -x polybar >/dev/null; do sleep 1; done
  fi

  local config="$1" ; shift
  local -a bars=("${@}")

  if ! [[ -e "$config" ]]; then
    log::err "Configuration file not found: $config"; exit 2
  fi

  for bar in ${bars[*]}; do
    if ! grep -q "\[bar/${bar}\]" "$config"; then
      log::err "The bar '${bar}' is not defined in the configuration, skipping..."; continue
    fi

    polybar "$bar" -c "$config" -r 2>"$XDG_CACHE_HOME/polybar/stderr" &

    log::info "Launched bar '${bar}'"
  done

  echo "$config" "${bars[@]}" > "$XDG_CONFIG_HOME/polybar/.runargs"
}

main "$@"

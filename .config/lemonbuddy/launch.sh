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
    killall -9 -q lemonbuddy ; shift
  fi

  local config="$1" ; shift
  local -a bars=("${@}")

  if ! [[ -e "$config" ]]; then
    log::err "Configuration file not found: $config"; exit 2
  fi

  for bar in ${bars[*]}; do
    log::info "Launching bar '${bar}'"

    monitor="$(lemonbuddy "$bar" -c "$config" -d monitor)"

    if ! x11::monitor_connected "$monitor"; then
      log::err "The bar '${bar}' is configured for disconnected monitor '${monitor}', skipping..."
      continue
    fi

    wmname=$(lemonbuddy "$bar" -c "$config" -w)

    if [[ -z "$wmname" ]]; then
      log::err "Failed to get WM_NAME for the bar '${bar}', skipping..."
      continue
    fi

    # XXX: Use development binary if available
    if lemonbuddy -h | grep -q "pipe=FILE"; then
      lemonbuddy_wrapper "$bar" -c "$config" &
    else
      lemonbuddy "$bar" -c "$config" &
    fi

    # If the binary handles restacking internally we're done
    if lemonbuddy -h | grep -q "restack"; then
      continue
    fi

    retries=0
    while (( retries++ < 10 )); do
      local root_win
      local bar_win

      sleep 1

      if pidof bspwm >/dev/null; then
        root_win=$(x11::root_win_bspwm "$monitor")
      elif pidof i3 >/dev/null; then
        root_win=$(x11::root_win_i3 "$monitor")
      else
        root_win=$(x11::root_win "$monitor")
      fi

      bar_win=$(x11::wmname_win "$wmname")

      if [[ "$root_win" ]] && [[ "$bar_win" ]]; then
        xdo above -t "$root_win" "$bar_win"
        log::ok "Successfully restacked bar window (root=${root_win} bar=${bar_win})"
        # ...at least we assume we did
        break
      else
        log::warn "Could not restack bar window (root=${root_win} bar=${bar_win}), retrying in 1s..."
      fi

      if [[ $retries -eq 10 ]]; then
        log::err "Failed to restack bar window 10 times, skipping..."
      fi
    done
  done
}

main "$@"

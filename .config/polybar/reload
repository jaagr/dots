#!/usr/bin/env bash

source bootstrap.sh

include utils/log.sh

bootstrap::finish

function main
{
  local -a args=()

  IFS=' '
  args+=($(cat "$XDG_CONFIG_HOME/polybar/.runargs"))

  log::info "Reloading polybar instances using:"
  log::info "launch ${args[*]}"

  "$XDG_CONFIG_HOME/polybar/launch" -k "${args[@]}"
}

main "$@"

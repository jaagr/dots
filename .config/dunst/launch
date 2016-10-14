#!/usr/bin/env bash
config="${1:-$LOCAL_ETC/dunst/dunstrc}"

if [[ $# -eq 0 ]] && [[ -s "$CURRENT_THEME"/dunst ]]; then
  config="$CURRENT_THEME"/dunst
fi

killall -q dunst &> /dev/null

exec dunst -config "$config"

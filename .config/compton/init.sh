#!/usr/bin/env bash
#
# Launcher for Compton compositor
#
config="${1:-$LOCAL_ETC/compton/compton.conf}"
log="${2:-$XDG_CACHE_HOME/compton/log}"

if [[ $# -eq 0 ]] && [[ -s "${CURRENT_THEME}/compton" ]]; then
  config="${CURRENT_THEME}/compton"
fi

# Make sure there's no process up and running
killall -q compton &> /dev/null

# NOTE: --logpath is required when using --daemon since compton freopen() all output to /dev/null
exec compton --xrender-sync-fence --daemon --config "$config" --logpath "$log"

#!/usr/bin/env bash
config="${1:-$LOCAL_ETC/sxhkd/sxhkdrc}"
cmdlog="${2:-$XDG_CACHE_HOME/sxhkd/cmdlog}"

# Make sure we replace any running instances
killall -q sxhkd &> /dev/null

echo "Starting sxhkd using:"
echo "sxhkd -t 2 -c $config -r $cmdlog"

exec sxhkd -t 2 -c "$config" -r "$cmdlog" > "$XDG_CACHE_HOME/sxhkd/stdout" 2> "$XDG_CACHE_HOME/sxhkd/stderr"

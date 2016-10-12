echo

# Compile the completion dump to increase startup speed.
{ zcompdump="$ZDOTDIR/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Check for package updates
# if command -v checkforupdates >/dev/null && ! [[ -e /tmp/checkforupdates.lock ]]; then
#   touch /tmp/checkforupdates.lock
#   checkforupdates
# fi

# Launch X at tty1 login
if ! [[ "$DISPLAY" ]] && [[ "${TTY##*tty}" == "1" ]] && command -v wm_launcher >/dev/null; then
  if command -v runlocked >/dev/null; then
    runlocked wm_launcher
  else
    wm_launcher
  fi
fi

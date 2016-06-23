# Compile the completion dump to increase startup speed.
{ zcompdump="$ZDOTDIR/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Launch X at tty1 login
if ! [[ "$DISPLAY" ]] && [[ "${TTY##*tty}" == "1" ]]; then
  printf "\n"

  # Show information about disk usage
  dfc -t btrfs 2>/dev/null -n -w -W -c always | cut -c29-

  printf "\n"

  # Check for package updates
  [[ -x $HOME/bin/checkforupdates ]] && $HOME/bin/checkforupdates

  printf "\n"

  if [[ -x $HOME/bin/logger ]]; then
    printf "%s" "$($HOME/bin/logger info "Press enter to launch WM (Ctrl-C to skip to terminal)...")"
  else
    printf "%s" "Press enter to launch WM (Ctrl-C to skip to terminal)..."
  fi

  [[ "$X11_INIT" ]] && {
    read -k 1 && printf "\n" && launch_wm='true'
  }
fi

${launch_wm:-false} && $X11_INIT

function util::vi-bind-ins {
  bindkey -M viins $@
}

function util::vi-bind-cmd {
  bindkey -M vicmd $@
}

function util::vi-bind {
  bindkey -M viins $@
  bindkey -M vicmd $@
}

function util::exec-on-fileupdate {
  local h1="$(md5sum $1)"
  vim $1 ; shift
  local h2="$(md5sum $1)"

  if [[ "$h1" == "$h2" ]]; then
    "$@"
  fi
}

function util::mpd-restart {
  local play='false'

  silent! pgrep -x mpd || return
  silent! grep playing <(mpc status) && {
    play='true'
  }

  mpd -f ; $play && mpc play
}

function util::xkb-loadmap {
  setxkbmap $1 -print | xkbcomp - "$DISPLAY"
}

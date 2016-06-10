pmodload 'helper'

# zle::preprocess-cmd {{{

function zle::preprocess-cmd {
  # Edit command
  [[ ${BUFFER:(-2)} == "??" ]] && {
    LBUFFER="vim $(which ${BUFFER:0:-2})"
  }

  # Locate command
  [[ ${BUFFER:(-1)} == "?" ]] && [[ ${BUFFER:(-2):1} != "$" ]] && {
    LBUFFER="which ${BUFFER:0:(-1)}";
  }

  zle .accept-line
}

zle -N accept-line zle::preprocess-cmd

# }}}
# zle::preprocess-key {{{

function zle::preprocess-key {
  zle .self-insert

  [[ ${BUFFER:(-2)} == '~?' ]] && LBUFFER="${LBUFFER:0:(-1)}/"
  [[ ${BUFFER} == 'kk' ]] && zle up-history && zle vi-cmd-mode

  is-callable '_zsh_highlight' && _zsh_highlight
}

zle -N self-insert zle::preprocess-key

# }}}

# zle::redo-cmd {{{

function zle::redo-cmd {
  zle up-history
  zle accept-line
}

zle -N zle::redo-cmd

function zle::redo-cmd-if-empty {
  [[ ${#BUFFER} -gt 0 ]] && return
  zle up-history
  zle accept-line
}

zle -N zle::redo-cmd-if-empty

# }}}
# zle::redo-sudo {{{

function zle::redo-sudo {
  [[ -z $BUFFER ]] && zle up-history
  [[ $BUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
  zle accept-line
}

zle -N zle::redo-sudo

# }}}
# zle::cmd-help {{{

function zle::cmd-help {
  # TODO: If there are no man page try -h and --help
  [[ -z $BUFFER ]] && zle up-history && zle accept-line
  [[ $BUFFER != man\ * ]] && LBUFFER="man $LBUFFER" && zle accept-line
}

zle -N zle::cmd-help

# }}}
# zle::quit-shell {{{

function zle::quit-shell {
  BUFFER="exit" ; zle accept-line
}

zle -N zle::quit-shell

# }}}

# vim:fdm=marker

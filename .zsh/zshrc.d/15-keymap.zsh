KEYTIMEOUT=20

util::vi-bind ';q' zle::quit-shell
util::vi-bind ':q' zle::quit-shell
util::vi-bind ',q' zle::quit-shell

util::vi-bind-ins '^[S' zle::redo-cmd

util::vi-bind-ins '^P' up-line-or-search     # ctrl-p
util::vi-bind-ins '^N' down-line-or-search   # ctrl-n
util::vi-bind-ins '^K' up-line-or-search     # ctrl-k
util::vi-bind-ins '^J' down-line-or-search   # ctrl-j

util::vi-bind-ins '^A' beginning-of-line     # ctrl-a
util::vi-bind-ins '^E' end-of-line           # ctrl-e

util::vi-bind-ins '^h' backward-delete-char  # ctrl-h
util::vi-bind-ins '^[^?' backward-kill-word  # alt-backspace
util::vi-bind-cmd '^?' backward-delete-char  # backspace (delete char in command mode)
util::vi-bind '^[[3~' delete-char            # delete key

util::vi-bind '^[OH' vi-beginning-of-line    # home
util::vi-bind '^[OF' vi-end-of-line          # end

util::vi-bind-ins '^[[1;5C' forward-word     # ctrl-right
util::vi-bind-ins '^[[1;3C' forward-word     # alt-right
util::vi-bind-ins '^[[1;5D' backward-word    # ctrl-left
util::vi-bind-ins '^[[1;3D' backward-word    # alt-left

util::vi-bind-ins 'jj' vi-cmd-mode           # double j
util::vi-bind-ins '^X^E' edit-command-line   # ctrl+x ctrl+e
util::vi-bind-ins '^r' history-incremental-search-backward

# autoload -U up-line-or-search
util::vi-bind-ins 'kk' zle::redo-cmd-if-empty
util::vi-bind-ins 'kj' zle::redo-cmd-if-almost-empty

# Fix keyboard
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kich1]}" overwrite-mode
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# vim:fdm=marker

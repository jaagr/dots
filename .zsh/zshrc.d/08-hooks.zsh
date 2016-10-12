# function hook::help-flag {
#   [[ $? -eq 0 ]] && return
#
#   prev_cmd=$history[$[HISTCMD-1]]
#
#   if command -v "${prev_cmd%% *}" &>/dev/null && [[ "${prev_cmd##* }" == "-h" ]]; then
#     eval "${prev_cmd%% *} --help"
#   fi
# }

# add-zsh-hook precmd hook::help-flag

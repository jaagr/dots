#!/usr/bin/env bash

banner() {
  local spaces=$1 ; shift
  local msg="${1:- }"
  local length="${#msg}"

  padding=$(printf "%*s" $(( (spaces - length) / 2 )))

  echo -e "\033[41;37;1m${padding}${msg}${padding}\033[0m"
}

banner 30
banner 30 "Launching X11 at $X11_VT"
banner 30

#if ps -C Xorg >/dev/null; then
#  vt=${X11_VT##*vt}
#  display=${X11_DISPLAY##*:}
#  X11_SERVER=${X11_SERVER//$X11_DISPLAY/:$(( $display + 1 ))}
#  X11_SERVER=${X11_SERVER//$X11_VT/vt$(( vt - 1 ))}
#fi

# Make $HOME the session root
cd ~

$X11_CLIENT -- $X11_SERVER >$XDG_CACHE_HOME/xorg/init.log 2>&1

echo -e "\n\033[31;1m-- returning to shell\033[0m"

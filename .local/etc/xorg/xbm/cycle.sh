#!/bin/sh

main() {
  fg="${1:-#000}"
  bg="${2:-#fff}"

  for xbm in **/*.xbm; do
    echo "xsetroot -bg '${bg}' -fg '${fg}' -bitmap ${xbm}"
    xsetroot -bg "${bg}" -fg "${fg}" -bitmap "${xbm}"
    read -r x
  done
}

main "$@"

function svlocal {
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 command service"
    return
  fi
  local args=("${*[@]:1:(-1)}")
  local service="${LOCAL_VAR}/service/${*##* }"
  [[ ${#args[@]} -eq 0 ]] && {
    args+=("status")
  }
  sv "${args[@]}" "$service"
}

function svlogcurrent {
  log=$(ps -C runsvdir -o command --no-heading)
  echo $log
  echo ${#log}
}

function svlogtail {
  if [ $# -eq 0 ]; then
    tail -n5 /var/log/sv/*/current
    tail -Fq -n0 /var/log/sv/*/current | uniq
  else
    old=
    cur=
    for log; do
      if [ -d /var/log/sv/$log ]; then
        if ls /var/log/sv/$log/*.[us] >/dev/null 2>&1; then
          old="$old /var/log/sv/$log/*.[us]"
        fi
        cur="$cur /var/log/sv/$log/current"
      else
        echo "no logs for $log" 1>&2
        return 1
      fi
    done
    cat $old $cur | sort
    tail -Fq -n0 $cur
  fi
}

function svlogtail-local {
  if [ $# -eq 0 ]; then
    tail -n5 $LOCAL_VAR/svlog/*/current
    tail -Fq -n0 $LOCAL_VAR/svlog/*/current | uniq
  else
    old=
    cur=
    for log; do
      if [ -d $LOCAL_VAR/svlog/$log ]; then
        if ls $LOCAL_VAR/svlog/$log/*.[us] >/dev/null 2>&1; then
          old="$old $LOCAL_VAR/svlog/$log/*.[us]"
        fi
        cur="$cur $LOCAL_VAR/svlog/$log/current"
      else
        echo "no logs for $log" 1>&2
        return 1
      fi
    done
    cat $old $cur | sort
    tail -Fq -n0 $cur
  fi
}

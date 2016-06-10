function svlogcurrent {
  log=$(ps -C runsvdir -o command --no-heading)
  echo $log
  echo ${#log}
}

function svlogtail {
  if [ $# = 0 ]; then
    cat /var/log/sv/*/current | sort -u
    tail -Fq -n0 /var/log/sv/*/current | uniq
  else
    old=
    cur=
    for log; do
      if [ -d /var/log/$log ]; then
        if ls /var/log/$log/*.[us] >/dev/null 2>&1; then
          old="$old /var/log/$log/*.[us]"
        fi
        cur="$cur /var/log/$log/current"
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
  if [ $# = 0 ]; then
    cat $LOCAL_VAR/svlog/*/current | sort -u
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

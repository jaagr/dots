function void-clean-kernels
{
  local -i keep_count=${1:-2}
  print "Clearing old kernels... ignoring the ${keep_count} latest"
  for kernel in $(vkpurge list | head -n-${keep_count}); do
    sudo vkpurge rm "$kernel"
  done
}

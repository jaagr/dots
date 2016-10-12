#
# Environment for interactive sessions
#

setopt sunkeyboardhack

fpath=(
  $ZDOTDIR/functions
  $ZDOTDIR/compdef
  $fpath
)

for rc in $ZDOTDIR/zshrc.d/*; do
  source $rc
done
unset rc

prompt jaagr

# vim:fdm=marker

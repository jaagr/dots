#
# Environment for interactive sessions
#

setopt sunkeyboardhack
#setopt complete_aliases

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

# compsys initialization
autoload -Uz compinit
compinit

# vim:fdm=marker

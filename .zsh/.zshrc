#
# Environment for interactive sessions
#

if [[ "$ZSH_DEBUG" ]]; then
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>/tmp/zsh_startup.$$
  setopt xtrace prompt_subst
fi

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

if [[ "$ZSH_DEBUG" ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
fi

# vim:fdm=marker

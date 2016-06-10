if [[ -s "$ZDOTDIR/zprezto/init.zsh" ]]; then
  source "$ZDOTDIR/zprezto/init.zsh"

  # Fix hardcoded prezto stuff
  alias ll='ls --dereference-command-line-symlink-to-dir -lh'
  alias gd='git diff'
  export GREP_COLORS="mt=30;43"
fi

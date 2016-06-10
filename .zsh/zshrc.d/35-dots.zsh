unalias dots
unalias dots-ls-untracked

function dots {
  [[ $# -eq 0 ]] && {
    set -- "status"
  }
  git --git-dir=$HOME/.dots.git --work-tree=$HOME "$@"
}
compdef _git dots="git"

function dots-ls-untracked {
  [[ $# -eq 0 ]] && {
    set -- "."
  }
  dots status -u "$@"
}

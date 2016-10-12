#
# Extra aliases
#

alias cfg.bspwm="util::exec-on-fileupdate $XDG_CONFIG_HOME/bspwm/bspwmrc $XDG_CONFIG_HOME/bspwm/reload"
alias cfg.compton="util::exec-on-fileupdate $XDG_CONFIG_HOME/compton/compton.conf $XDG_CONFIG_HOME/compton/reload"
alias cfg.i3="util::exec-on-fileupdate $XDG_CONFIG_HOME/i3/config 'pgrep i3 && $XDG_CONFIG_HOME/i3/restart'"
alias cfg.irssi="vim $HOME/.irssi/config"
alias cfg.lemonbuddy="vim $XDG_CONFIG_HOME/lemonbuddy/config"
alias cfg.mpd="util::exec-on-fileupdate $XDG_CONFIG_HOME/mpd/mpd.conf routine::mpd-restart"
alias cfg.ncmpcpp="vim $XDG_CONFIG_HOME/ncmpcpp/config"
alias cfg.sxhkd="util::exec-on-fileupdate $XDG_CONFIG_HOME/sxhkd/sxhkdrc $XDG_CONFIG_HOME/sxhkd/reload"
alias cfg.termite="util::exec-on-fileupdate $XDG_CONFIG_HOME/termite/config $XDG_CONFIG_HOME/termite/reload"
alias cfg.zsh="vim $ZDOTDIR/zshrc && source $ZDOTDIR/zshrc"
alias cfg.zshenv="vim $ZDOTDIR/zshenv && source $ZDOTDIR/zshenv"
alias cfg.vim="vim $HOME/.vim/vimrc"

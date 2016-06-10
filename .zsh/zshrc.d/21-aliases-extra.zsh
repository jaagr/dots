#
# Extra aliases
#

alias cfg.bspwm="util::exec-on-fileupdate $LOCAL_ETC/bspwm/bspwmrc $LOCAL_ETC/bspwm/bin/reload"
alias cfg.compton="util::exec-on-fileupdate $LOCAL_ETC/compton/compton.conf $LOCAL_ETC/compton/bin/reload"
alias cfg.i3="util::exec-on-fileupdate $LOCAL_ETC/i3/config 'pgrep i3 && $LOCAL_ETC/i3/bin/restart'"
alias cfg.irssi="vim $LOCAL_ETC/irssi/config"
alias cfg.lemonbuddy="vim $LOCAL_ETC/lemonbuddy/config"
alias cfg.mpd="util::exec-on-fileupdate $LOCAL_ETC/mpd/mpd.conf routine::mpd-restart"
alias cfg.ncmpcpp="vim $LOCAL_ETC/ncmpcpp/config"
alias cfg.sxhkd="util::exec-on-fileupdate $LOCAL_ETC/sxhkd/sxhkdrc $LOCAL_ETC/sxhkd/bin/reload"
alias cfg.termite="util::exec-on-fileupdate $LOCAL_ETC/termite/config $LOCAL_ETC/termite/reload"
alias cfg.zsh="vim $ZDOTDIR/zshrc && source $ZDOTDIR/zshrc"
alias cfg.zshenv="vim $ZDOTDIR/zshenv && source $ZDOTDIR/zshenv"

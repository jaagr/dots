#
# Audio
#

XF86AudioMute
    ~/bin/toggle_mute

XF86Audio{Raise,Lower}Volume
    amixer -q -c 0 set Master playback 1dB{+,-}

XF86AudioPlay
    mpc -q toggle

XF86Audio{Prev,Next}
    mpc -q {prev,next}

super + button{8,9}
    mpc -q {prev,next}

#
# Application launcher
#

super + Return
    termite

# super + d
#   $LOCAL_BIN/rofi_run

alt + Mode_switch
  $LOCAL_BIN/rofi_run

alt + Mode_switch + v
  $LOCAL_BIN/apps/vimperator

super + F12
  authy
super + F11
  lastpass
super + F10
  vimperator
super + F9
  pcmanfm

#
# Misc
#

super + r
    i3-msg mode resize

{shift + ,_}Print
    scrot {--select,_} '%F_%H-%M-%S_$wx$h.png' -e 'mv $f ~/vault/screenshots/ ' && notify-send 'Screenshot captured'

ctrl + shift + r
    pgrep compton && killall -q -USR1 compton ; \
    pgrep termite && killall -q -USR1 termite ; \
    pgrep sxhkd   && killall -q -USR1 sxhkd   ; \
    xrdb -merge -I$LOCAL_ETC/xorg $LOCAL_ETC/xorg/xresources 2> /dev/null

# Convenient scroll in terminal
alt + shift + {j,k}
  xmatch -x "termite\([0-9]+\)-\+-zsh\([0-9]+\)" && \
    xdotool keyup j k key Page_{Down,Up}

super + shift + KP_{1,2,3,4,6,7,8,9}
    xdotool mousemove_relative -- {-20 20,0 20,20 20,-20 0,20 0,-20 -20,0 -20,20 -20}

super + shift + KP_5
    xdotool click 1

# vim:ft=sxhkdrc

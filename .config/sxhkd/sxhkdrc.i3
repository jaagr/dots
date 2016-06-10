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

super + r
    ~/bin/show_dmenu

super + Return
    termite

# q; kill focused window
alt + Mode_switch ; q
    pfw | xargs killw

# enter; open terminal
alt + Mode_switch ; alt + Mode_switch
    termite

# vi; launch vimperator
alt + Mode_switch ; v ; i
    ~/dotfiles/vimperator/launch

# vi; show dmenu
alt + Mode_switch ; d ; m
    ~/bin/show_dmenu

# vi; enter window resize mode
alt + Mode_switch ; w ; r
    i3-msg mode resize

#
# Misc
#

{shift + ,_}Print
    scrot {--select,_} '%F_%H-%M-%S_$wx$h.png' -e 'mv $f ~/vault/screenshots/ ' && notify-send 'Screenshot captured'

ctrl + shift + r
    pgrep compton && killall -q -USR1 compton ; \
    pgrep termite && killall -q -USR1 termite ; \
    pgrep sxhkd   && killall -q -USR1 sxhkd   ; \
    xrdb -merge -I$LOCAL_ETC/xorg $LOCAL_ETC/xorg/xresources 2> /dev/null

alt + shift + {j,k}
    xdotool keyup Alt_L keyup j keyup k key Page_{Down,Up} keydown Alt_L

super + shift + KP_{1,2,3,4,6,7,8,9}
    xdotool mousemove_relative -- {-20 20,0 20,20 20,-20 0,20 0,-20 -20,0 -20,20 -20}

super + shift + KP_5
    xdotool click 1

# vim:ft=sxhkdrc

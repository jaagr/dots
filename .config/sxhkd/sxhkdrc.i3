#
# Defines keymap for sxhkd
#

# WM {{{

# Focus
super + k
  i3-msg focus up || i3-msg focus output up
super + j
  i3-msg focus down || i3-msg focus output down
super + h
  i3-msg focus left || i3-msg focus output left
super + l
  i3-msg focus right || i3-msg focus output right

# Swap
super + shift + k
  i3-msg move up
super + shift + j
  i3-msg move down
super + shift + h
  i3-msg move left
super + shift + l
  i3-msg move right

# Set splitting area
super + ctrl + {j,l}
  i3-msg split{v,h}

# Cycle non-empty between workspaces and outputs
super + {_,ctrl + }bracket{left,right}
  i3-msg {workspace,output} {prev,next}_on_output

# Cycle between all workspaces and outputs
super + shift + {_,ctrl + }bracket{left,right}
  i3-msg {workspace,output} {prev,next}

# Toggle fullscreen/floating state
super + f
  i3-msg fullscreen
super + ctrl + f
  i3-msg floating toggle
super + shift + f
  i3-msg floating toggle

# Close/kill current window
super + q
  i3-msg kill window

# Move workspace
super + y
  i3-msg move workspace to output up

# Cycle between windows
super + {_,shift + }n
  i3-msg focus{up,down}

# Focus clicked node
#~button1
#  bspc pointer -g focus

#super + button{1-3}
#  ; bspc pointer -g {move,resize_side,resize_corner}

#super + @button{1-3}
#  bspc pointer -u

# Reload configuration
super + Escape
  $LOCAL_ETC/dunst/reload ; \
    sleep 0.1 ; \
  $LOCAL_ETC/sxhkd/reload ;  \
  $LOCAL_ETC/i3/reload && \
    notify-send -u low "i3 reloaded successfully" || \
    notify-send -u low "failed to reload i3"; \
  $LOCAL_ETC/compton/reload && \
    notify-send -u low "compton reloaded successfully" || \
    notify-send -u low "failed to reload compton"; \
  bash -c 'sleep 3 && xdotool click 1' &

# Quit
super + shift + Escape
  bspc quit 1

# }}}
# Audio {{{

@XF86AudioMute
  $LOCAL_BIN/mute

@XF86Audio{Raise,Lower}Volume
  amixer -q -c 0 set Master playback 1dB{+,-}

@XF86AudioPlay
  mpc -q toggle

@XF86AudioStop
  mpc stop

@XF86Audio{Prev,Next}
  mpc -q {prev,next}

super + @button{8,9}
  mpc -q {prev,next}

super + {KP_Add,KP_Subtract}
  $LOCAL_BIN/volume_change {+,-}5

# }}}
# Application launcher {{{

super + Return
  termite 2>/dev/null
super + shift + Return
  urxvt -e zsh

super + d
  $LOCAL_BIN/rofi_run

alt + Mode_switch
  $LOCAL_BIN/rofi_run

# # vi; launch vimperator
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
# }}}
# Misc {{{

# Toggle keyboard layouts
super + F8
  $LOCAL_BIN/kblayout

{shift + ,_} Print
  scrot {--select,_} '%F_%H-%M-%S_$wx$h.png' -e 'mv $f ~/ ' && notify-send 'Screenshot captured'
  #scrot {--select,_} '%F_%H-%M-%S_$wx$h.png' -e 'mv $f ~/vault/screenshots/ ' && notify-send 'Screenshot captured'
#@Print
#  maim "/tmp/$(date +%W.%A)-scrot$(date +%s | tail -c 5).png" && \
#  notify-send -a maim "Took a screenshot (full screen)."
#ctrl + @Print
#  maim -i $(xdotool getactivewindow) "/tmp/$(date +%W.%A)-window$(date +%s | tail -c 5).png" && \
#  notify-send -a maim "Took a screenshot (window)."
#ctrl + shift + @Print
#  maim -s -c 0.1,0.05,0.3,1 "/tmp/$(date +%W.%A)-slop$(date +%s | tail -c 5).png" && \
#  notify-send -a maim "Took a screenshot (area)."

super + ctrl + shift + r
  $LOCAL_ETC/termite/reload; \
  $LOCAL_ETC/compton/reload; \
  $LOCAL_ETC/sxhkd/reload; \
  silent! xrdb -merge -I$LOCAL_ETC/xorg $LOCAL_ETC/xorg/xresources

# Convenient scroll in terminal
alt + shift + {j,k}
  xmatch -x "termite\([0-9]+\)-\+-zsh\([0-9]+\)" && \
    xdotool keyup j k key Page_{Down,Up}

super + Pause
  $LOCAL_BIN/random_wallpaper "/storage/media/wallpapers/rave_collection2"

# TODO: Find out how to exec a cmd when entering/leaving chord chain
# Change key repeat rate to 50ms
# xset r rate 50
# Reset key repeat rate
# xset r rate

# Move cursor
super + ctrl + m : {_,shift + ,shift + super + }{h,j,k,l}
  m={20,100,200} {x=-1 y=0,x=0 y=1,x=0 y=-1,x=1 y=0}; \
  xdotool mousemove_relative -- $(( m*x )) $(( m*y ))

# Move cursor to monitor corners
super + ctrl + m : super + {h,j,k,l}
  x=$(bspc query -T -d | json root.rectangle.x); x=$(( x + 50 )); \
  y=$(bspc query -T -d | json root.rectangle.y); y=$(( y + 50 ));  \
  w=$(bspc query -T -d | json root.rectangle.width); w=$(( w - 100 )); \
  h=$(bspc query -T -d | json root.rectangle.height); h=$(( h - 100 )); \
  dx=$(( x + w ));  dy=$(( y + h )); \
  xdotool mousemove {$x $y,$x $dy,$dx $y,$dx $dy}

# Simulate mouse button click
super + ctrl + m : {_,shift + ,ctrl + }space
  xdotool click {1,3,2}

super + ctrl + @F{1,2,3,4,5,6,7,8,9,10,11,12}
  sudo chvt {1,2,3,4,5,6,7,8,9,10,11,12}
# }}}

# vim:ft=sxhkdrc

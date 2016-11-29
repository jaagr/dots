[bar/test]
monitor = eDP-1
width = 100%
height = 20
dock = false
lineheight = 10
background = #ff184f
foreground = #000
linecolor = #c51850
;offset-x = 850
;offset-y = 450

padding-left = 2
padding-right = 2

font-0 = envypn:weight=bold:pixelsize=13;0
font-1 = fontawesome:size=10;0
font-2 = materialicons:size=10;0

modules-center = filesystem

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /
mount-1 = /home
mount-2 = /invalid/mountpoint

;fixed-values = true
;spacing = 4

label-mounted = %mountpoint%: %percentage_free%

label-unmounted = %mountpoint%: not mounted
label-unmounted-foreground = #55

# vim:ft=dosini

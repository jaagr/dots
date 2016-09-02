[bar/test]
monitor = eDP-1
bottom = true

background = #222222
foreground = #ccfafafa
linecolor = #666

spacing = 1
padding_left = 2
padding_right = 2
module_margin_left = 1
module_margin_right = 2

font-0 = envypn-regular:size=10;0
font-1 = Siji:pixelsize=10;0

modules-left = i3


[module/i3]
type = internal/i3
format = <label-state>

workspace_icon-0 = term;
workspace_icon-1 = web;
workspace_icon-2 = code;
workspace_icon-3 = music;
workspace_icon-4 = irssi;
workspace_icon-default = 

local_workspaces = true
workspace_name_strip_nchars = 2

label-focused = %index% %icon%
label-focused-background = #3f3f3f
label-focused-padding = 2
label-visible = %index% %icon%
label-visible-padding = 2
label-unfocused = %index% %icon%
label-unfocused-foreground = #444
label-unfocused-padding = 2
label-urgent = %index% %icon%
label-urgent-background = #bd2c40
label-urgent-padding = 2

; vim:ft=dosini

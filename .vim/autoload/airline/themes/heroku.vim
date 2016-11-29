let g:airline#themes#heroku#palette = {}

nmap <leader><f1> :so %<cr>:AirlineTheme heroku<cr>

func! airline#themes#heroku#refresh()
  let l:white = 255
  let l:blue = 26
  let l:grey = 8

  let l:bottom_bg = 0
  let l:bottom_fg = 240

  let s:N1 = [ '', '', white, blue, '' ]
  let s:N2 = [ '', '', white, grey, '' ]
  let s:N3 = [ '', '', bottom_fg, bottom_bg, '' ]
  let g:airline#themes#heroku#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#heroku#palette.normal_modified = {}
  let g:airline#themes#heroku#palette.normal_modified.airline_c = [ '', '', 214, '', '' ]
  let g:airline#themes#heroku#palette.normal_paste = {}
  let g:airline#themes#heroku#palette.normal_paste.airline_a = [ '', '', white, 197, '', ''  ]
  let g:airline#themes#heroku#palette.normal_paste.airline_b = [ '', '', 19, 7, '', ''  ]
  let g:airline#themes#heroku#palette.normal_paste.airline_c = [ '', '', 19, 249, '', '' ]
  let g:airline#themes#heroku#palette.normal_paste.airline_z = [ '', '', 19, 7, '', '' ]
  let g:airline#themes#heroku#palette.normal_paste.airline_y = [ '', '', 234, 249, '', '' ]
  let g:airline#themes#heroku#palette.normal_paste.airline_x = [ '', '', 19, 244, '', '' ]

  let s:I1 = [ '', '', 234, 148 ]
  let s:I2 = [ '', '', white, 8 ]
  let s:I3 = [ '', '', white, 0 ]
  let g:airline#themes#heroku#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#heroku#palette.insert_paste = {}
  let g:airline#themes#heroku#palette.insert_paste.airline_a = [ '', '', white, 197, '', ''  ]
  let g:airline#themes#heroku#palette.insert_paste.airline_b = [ '', '', white, 197, '', ''  ]
  let g:airline#themes#heroku#palette.insert_paste.airline_c = [ '', '', white, 197, '', '' ]
  let g:airline#themes#heroku#palette.insert_paste.airline_z = [ '', '', white, 197, '', '' ]
  let g:airline#themes#heroku#palette.insert_paste.airline_y = [ '', '', white, 197, '', '' ]
  let g:airline#themes#heroku#palette.insert_paste.airline_x = [ '', '', white, 197, '', '' ]

  let g:airline#themes#heroku#palette.replace = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#heroku#palette.replace.airline_a = [ '', '', 234, 3 ]
  let g:airline#themes#heroku#palette.replace.airline_b = [ '', '', 234, 3 ]
  let g:airline#themes#heroku#palette.replace.airline_c = [ '', '', 234, 3 ]
  let g:airline#themes#heroku#palette.replace.airline_z = [ '', '', 234, 3 ]
  let g:airline#themes#heroku#palette.replace.airline_y = [ '', '', 234, 3 ]
  let g:airline#themes#heroku#palette.replace.airline_x = [ '', '', 234, 3 ]

  let g:airline#themes#heroku#palette.visual = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#heroku#palette.visual.airline_a = [ '', '', bottom_bg, 252 ]
  let g:airline#themes#heroku#palette.visual.airline_b = [ '', '', bottom_bg, 247 ]
  let g:airline#themes#heroku#palette.visual.airline_c = [ '', '', 254, 241 ]
  let g:airline#themes#heroku#palette.visual.airline_x = [ '', '', 254, 241 ]
  let g:airline#themes#heroku#palette.visual.airline_y = [ '', '', bottom_bg, 247 ]
  let g:airline#themes#heroku#palette.visual.airline_z = [ '', '', bottom_bg, 252 ]

  let s:IA1 = [ '', '', bottom_fg, bottom_bg ]
  let s:IA2 = [ '', '', bottom_fg, bottom_bg ]
  let s:IA3 = [ '', '', bottom_fg, bottom_bg ]
  let g:airline#themes#heroku#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

  " let g:airline_theme_patch_func = 'AirlineThemePatch'
  " function! AirlineThemePatch(palette)
  "   if has_key(a:palette, 'inactive')
  "     for colors in values(a:palette.inactive)
  "       let colors[2] = bottom_fg
  "       let colors[3] = bottom_bg
  "     endfor
  "   endif
  " endfunction
endfunc

call airline#themes#heroku#refresh()

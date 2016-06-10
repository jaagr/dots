let g:airline#themes#jaagr#palette = {}

nmap <leader><f1> :so %<cr>:AirlineTheme jaagr<cr>

func! airline#themes#jaagr#refresh()
  let l:white = 15
  let l:blue = 25
  let l:grey = 8

  let l:top_bg = grey
  let l:top_fg = white

  let l:bottom_bg = 'black'
  let l:bottom_fg = 240


  if $term == "linux"
    let l:white = 7
    let l:blue = 25
    let l:grey = 8
  endif


  let s:N1 = [ '', '', white, blue, '' ]
  let s:N2 = [ '', '', top_fg, top_bg, '' ]
  let s:N3 = [ '', '', bottom_fg, bottom_bg, '' ]
  let g:airline#themes#jaagr#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jaagr#palette.normal_modified = {}
  let g:airline#themes#jaagr#palette.normal_modified.airline_c = [ '', '', 214, '', 'bold' ]
  let g:airline#themes#jaagr#palette.normal_paste = {}
  let g:airline#themes#jaagr#palette.normal_paste.airline_a = [ '', '', 16, 9, '' ]

  "let s:I1 = [ '', '', 23 , 14 ]
  "let s:I2 = [ '', '', 15 , 31 ]
  "let s:I3 = [ '', '', 255, 24 ]
  let s:I1 = [ '', '', 22, 2 ]
  let s:I2 = [ '', '', 15, 8]
  let s:I3 = [ '', '', 255, 'black']
  let g:airline#themes#jaagr#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
  let g:airline#themes#jaagr#palette.insert_paste = {}
  let g:airline#themes#jaagr#palette.insert_paste.airline_a = [ '', '', 16, 9, '' ]

  let g:airline#themes#jaagr#palette.replace = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jaagr#palette.replace.airline_a = [ '', '', 16, 9 ]

  let g:airline#themes#jaagr#palette.visual = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
  let g:airline#themes#jaagr#palette.visual.airline_a = [ '', '', 16, 3 ]

  let s:IA1 = [ '', '', 237, 'black', '' ]
  let s:IA2 = [ '', '', 237, 'black', '' ]
  let s:IA3 = [ '', '', 237, 'black', '' ]
  let g:airline#themes#jaagr#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)

  let g:airline#themes#jaagr#palette.accents = {}
  let g:airline#themes#jaagr#palette.accents.red = [ '', '', 167, 'black' ]
endfunc

call airline#themes#jaagr#refresh()

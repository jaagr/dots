"
" Coloring
"

syntax enable

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if $TERM == 'linux'
  let g:base16colorspace=8
  let &t_Co = 8
else
  let &t_Co = 256
endif

let g:theme_name = 'codeschool'
let g:airline_theme = 'lucius'

let s:colorsscheme_filename = expand('$CURRENT_THEME/vim')
if filereadable(s:colorsscheme_filename)
  exec 'source ' . s:colorsscheme_filename
endif

exec 'colorscheme '. g:theme_name

if g:theme_name[:5] == 'base16'
  hi Search ctermfg=0 guifg=#000000

  if &background == 'light'
    hi LineNr ctermbg=255 guibg=#eeeeee
    hi CursorLine ctermbg=255 guibg=#eeeeee
    hi CursorLineNr ctermbg=255 guibg=#eeeeee
    hi Folded ctermbg=255 ctermfg=246 guibg=#eeeeee guifg=#949494
    hi Conceal ctermbg=NONE ctermfg=251 guifg=#c6c6c6
    hi Todo cterm=bold ctermfg=19 ctermbg=NONE guifg=#0000af guibg=NONE
  else
    hi Todo cterm=bold ctermfg=15 ctermbg=NONE guifg=#ffffff guibg=NONE
    hi Folded ctermbg=0 ctermfg=240 guibg=NONE guifg=#4e4e4e
    hi LineNr ctermbg=0 ctermfg=240 guibg=NONE guifg=#4e4e4e
    hi CursorLine ctermbg=236 guibg=#303030
    hi CursorLineNr ctermbg=0 ctermfg=255 guibg=NONE guifg=#ffffff
    hi Conceal ctermbg=0 ctermfg=238 guibg=NONE guifg=#444444
  endif
elseif g:theme_name == 'gruvbox'
  if &background == 'light'
    hi VertSplit ctermfg=250 guifg=#bcbcbc
  else
    hi VertSplit ctermfg=240 guifg=#4e4e4e
  endif
elseif g:theme_name == 'lucius' && &background =='light'
  hi Conceal ctermbg=NONE ctermfg=254 guibg=NONE guifg=#e4e4e4
  hi Folded ctermbg=NONE ctermfg=242 cterm=NONE guibg=NONE guifg=#6c6c6c

  let g:airline_theme_patch_func = 'AirlineThemePatch'
  function! AirlineThemePatch(palette)
    if g:airline_theme == 'gruvbox'
      for colors in values(a:palette.inactive_modified)
        let colors[3] = 254
      endfor
    endif
  endfunction
elseif g:theme_name == 'brogrammer'
  hi LineNr ctermbg=NONE ctermfg=241 guibg=NONE guifg=#626262
  hi ColorColumn ctermbg=NONE guibg=NONE
  hi CursorLine ctermbg=NONE cterm=NONE ctermfg=5 cterm=underline guibg=NONE guifg=#800080
elseif g:theme_name == 'dracula'
  hi NonText ctermbg=NONE guibg=NONE
elseif &background == 'light'
  hi Conceal ctermbg=NONE ctermfg=254  guibg=NONE guifg=#e4e4e4
  hi Folded ctermbg=NONE guibg=NONE
else
  hi Conceal ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  hi Folded ctermbg=NONE guibg=NONE
endif

if $TERM == 'linux'
  hi MatchParen ctermbg=0 ctermfg=2 cterm=bold term=NONE
endif

" Highlight contents after column 80
"let &colorcolumn='80,'.join(range(120,500),',')
"highlight ColorColumn ctermbg=256 ctermfg=red

if exists('*g:ThemeHookPost')
  call ThemeHookPost()
endif

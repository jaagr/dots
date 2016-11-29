"
" Coloring
"
syntax enable

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

let &t_Co = 256

if $TERM == 'linux' && !has('gui')
  let &t_Co = 8
  let g:base16colorspace=8
endif

let g:theme_name = 'codeschool'
let g:airline_theme = 'lucius'

let s:colorsscheme_filename = expand('$CURRENT_THEME/vim')
if filereadable(s:colorsscheme_filename)
  exec 'source ' . s:colorsscheme_filename
endif

exec 'colorscheme '. g:theme_name

" Source colorscheme override files
let s:theme_override=expand('$HOME/.vim/after/colors/'. g:theme_name .'.vim')
if filereadable(s:theme_override)
  exec 'source ' . s:theme_override
endif

if $TERM == 'linux' && !has('gui')
  hi MatchParen ctermbg=0 ctermfg=2 cterm=bold term=NONE
elseif &background == 'light'
  hi Conceal ctermbg=NONE ctermfg=254  guibg=NONE guifg=#e4e4e4
  " hi Folded ctermbg=NONE guibg=NONE
else
  hi Conceal ctermbg=NONE ctermfg=238 guibg=NONE guifg=#444444
  " hi Folded ctermbg=NONE guibg=NONE
endif

if exists('*g:ThemeHookPost')
  call ThemeHookPost()
endif

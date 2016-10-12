let g:airline_powerline_fonts = 1

" let g:airline_section_b = "%{GetCurrentWorkingDir(25)}"
" let g:airline_section_c = "%#__accent_bold#%t%#__restore__#"
"
" let g:airline_section_y = "#%{bufnr('%')}"
" let g:airline_section_z = "%#__accent_bold#%3l%#__restore__#:%1v"

let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ":t"

let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline_powerline_fonts = 0
let g:airline_left_sep=''
let g:airline_right_sep=''

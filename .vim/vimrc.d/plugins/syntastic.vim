let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 4

" Enable perl
let g:syntastic_perl_checkers = ["perl"]
let g:syntastic_enable_perl_checker = 1

" Disable annoying shellcheck errors
let g:syntastic_sh_shellcheck_args = "--exclude=SC1090,SC1091,SC2034,SC2120,SC2154,SC2119"

" Disable Syntastic default error checking
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["perl","python","json", "java", "go", "c", "c++", "zsh", "sh", "vim"],
    \ "passive_filetypes": []
    \ }

let g:syntastic_ignore_files = ['\msrcpkgs/.*/template$', '\m\c\.h$']

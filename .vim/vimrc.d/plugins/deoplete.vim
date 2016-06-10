let g:deoplete#enable_at_startup = 1

" libclang shared library path
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
"let g:deoplete#sources#clang#libclang_path = '/opt/llvm/lib/libclang.so'

" clang builtin header path
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'

" C or C++ standard version
let g:deoplete#sources#clang#std#c = 'c11'
let g:deoplete#sources#clang#std#cpp = 'c++14'

" libclang complete result sort algorism
" Default: '' -> deoplete.nvim delault sort order
let g:deoplete#sources#clang#sort_algo = 'priority'
"let g:deoplete#sources#clang#sort_algo = 'alphabetical'

" compile_commands.json directory path
let g:deoplete#sources#clang#clang_complete_database = '/home/jaagr/.cache/neovim/build'

" debug
let g:deoplete#enable_debug = 1
let g:deoplete#sources#clang#debug#log_file = '/home/jaagr/.cache/neovim/log/deoplete-clang.log'

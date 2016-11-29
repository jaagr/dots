nnoremap <silent> <buffer> <cr> :CSearchContext<cr>
"exe 'source $HOME/.vim/plugin/a.vim'

nmap <leader>r :lcd %:p:h<cr>:!make && ./%< <cr>
nmap <f1> :ClangFormat<cr>

set formatprg=/usr/bin/clang-format

"if exists('*g:FSwitchBindings')
"  call FSwitchBindings()
"endif

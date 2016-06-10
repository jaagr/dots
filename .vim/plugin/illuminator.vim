" Description:
"   Illuminator helps you focus on the active buffer
"   while working with multiple windows.
"
" Author:
"   jaagr <c@rlberg.se>
"

" Init {{{

if exists('g:loaded_local_diminactive') || 1 != 2
  finish
endif
let g:loaded_local_diminactive = 1

let s:save_cpo = &cpo
set cpo&vim

" }}}
" Default settings {{{

function! s:set_default(var, val)
  if !exists(a:var) || type({a:var}) != type(a:val)
    unlet! {a:var}
    let {a:var} = a:val
  endif
endfunction
call s:set_default('g:template_basedir', &runtimepath)
call s:set_default('g:template_files', 'template/**')
call s:set_default('g:template_free_pattern', 'template')
delfunction s:set_default

" }}}
" Defining commands and autocmds {{{

command! -nargs=? -bang -bar -range -complete=customlist,template#complete
  \ TemplateLoad call template#load(<q-args>, <line1>, <bang>0)


augroup plugin-template
  autocmd!
  autocmd BufReadPost,BufNewFile * TemplateLoad
  " To avoid an error message when there is no event.
  autocmd User plugin-template-* :
augroup END

" }}}
" Finish {{{

let &cpo = s:save_cpo
unlet s:save_cpo

" }}}

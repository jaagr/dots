
" Helper and utility functions
"

command! Vimrc :execute ':e ~/.vim/vimrc'
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! FormatClang :execute ':ClangFormat'

func! CmdLine(str) " {{{
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunc

" }}}

func! GetUnicodeChar(code) " {{{
  exe "read !source ~/.zsh/zshrc.d/25-commands.zsh 2>/dev/null ; unicode ". a:code
endfunc

" }}}

func! GetCurrentWorkingDir(max_length) " {{{
  let l:cwd = substitute(getcwd(), '^/home/jaagr', '~', '').'/'
  if a:max_length && strlen(l:cwd) > a:max_length
    let l:cwd = l:cwd[:a:max_length].'...'
  endif
  return l:cwd
endfunc

" }}}

func! VisualReplace() " {{{
  let l:backup = @"

  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*$^~[]")
  let l:pattern = substitute(l:pattern, "\n", " ", "")

  let l:replacement = inputdialog("Replace with: ", "", 0)

  if l:replacement isnot 0
    call CmdLine(printf("%%s/%s/%s/g", l:pattern, l:replacement))
  endif

  let @" = l:backup
  let @/ = l:pattern

  execute "normal! gvv"
endfunc

" }}}

func! ToggleNumbers() " {{{
  set relativenumber!
  set number!
endfunc

" }}}

func! NeatFoldText() "{{{
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let vertchar = matchstr(&fillchars, 'fold:\zs.')
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*#\?"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = vertchar . ' ' . printf("%10s", lines_count . ' lines') . ' ' . vertchar
  let foldtextstart = strpart(vertchar . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunc

" }}}

func! PrintColors() "{{{
  let l:num = 255
  while l:num >= 0
    exec 'hi col_'.l:num.' ctermbg='.l:num.' ctermfg=white'
    exec 'syn match col_'.l:num.' "ctermbg='.l:num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.l:num.':....')
    let l:num = l:num - 1
  endwhile
endfunc

" }}}

func! <SID>CursorMoved() "{{{
  if bufname('%') =~ '^NERD_tree_'
    return
  endif
  let l:cur_pos = winline()
  if !g:last_pos
    set cul
    let g:last_pos = l:cur_pos
    return
  endif
  let l:diff = g:last_pos - l:cur_pos
  if l:diff > 1 || l:diff < -1
    set cul
  else
    set nocul
  endif
  let g:last_pos = l:cur_pos
endfunc

let g:last_pos = 0

augroup CursorJumpHint
  au CursorMoved,CursorMovedI * call <SID>CursorMoved()
augroup END

" }}}

func! <SID>CloseBuffer() "{{{
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunc

command! Bclose call <SID>CloseBuffer()

" }}}

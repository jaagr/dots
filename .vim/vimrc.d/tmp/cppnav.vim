" --------------------------------------------
" NOTE: This file is not sourced at the moment
" --------------------------------------------

" File:       cppnav.vim
" Author:     Sureshkumar Manimuthu (mail2msuresh AT yahoo DOT com)
" Version:      1.3
" Last Modified:  30-Nav-2013
"
" The "cppnav" is a source code navigation plugin for c++ and c files. It uses
" omnicppcomplete  plugin and ctag tool.
"
" FEATURES:
"  - Accurate navigation
"  - Jumping to member function and member variable of class/struct
"  - Jumping to files in #include directive
"  - Prototype preview of functions, macros and variables with single key press
"  - Function prototype preview while typing the function name(
"  - Tab based navigation
"     If the identifier is declared in a file in other tab then it jumps
"     to the tab instead of opening it in the current window.
"
"  g:cppnav_tab == 'never'
"   Disable tab navigation feature
"  g:cppnav_tab == 'always'
"   Always use tab navigation. Open a new tab if the file is not already opened
"  g:cppnav_tab == 'only'
"   Use tab navigation only if the file is already open in another tab or the
"   current file is not saved.
"
"  USAGE:
"   create the 'tags' file using ctag with following options
"   --fields=+iaS --extra=+fq
"
"   ctrl-]  = Jump to declaration
"   ctrl-t  = Jump back from declaration
"   <space> = Quick prototype preview (editor bottom)
"   _       = Preview the declaration file (preview window)
"   -       = Jump to the declaration file (preview window)
"
"
" INSTALL:
"  Install omnicppcomplete plugin from
"   http://www.vim.org/scripts/script.php?script_id=1520
"
"  copy the cppnav.vim to ~/.vim/plugin/ directory
"
"-------------------------------------------------------------------------------

" Check if the script is already loaded
if exists('g:cppnav_loaded') || &cp
    finish
endif
let g:cppnav_loaded = 1

if !exists('g:cppnav_tab')
  let g:cppnav_tab = 'only'
endif

" Stack for jump locations, so that we can come back
let s:tag_stack = []

" Load the key mapping for the c,c++ files
autocmd Filetype c call s:SetupMapping()
autocmd Filetype cpp call s:SetupMapping()

" Find the correct tag info for the given identifire
function s:FindTagInfo(type, ident, start)
  let Count = 0
  let StartCount = a:start

  for taginfo in taglist('^\C' . a:ident . "$")
    let Count = Count + 1
    let found = 0
    if has_key(taginfo, 'struct')
      if(a:type == taginfo.struct)
        let found = 1
      endif
    endif

    if has_key(taginfo, 'class')
      if(a:type == taginfo.class)
        let found = 1
      endif
    endif

    if has_key(taginfo, 'union')
      if(a:type == taginfo.union)
        let found = 1
      endif
    endif

    if(found == 1)
      if(StartCount)
        let StartCount = StartCount - 1
      else
        return taginfo
      endif
    endif
  endfor
  return {}
endfunction

" Alternate function for getting the tag info
" This needs clang_complete plugin
function s:GetCorrectTagAlt()
let result = {}
if has('python')
python << EOF
if getSymbolLocation is not None:
  loc = getSymbolLocation()
  if loc is not None and len(loc) >= 2 and loc[0] is not None and loc[1] is not None:
    vim.command("let result = { 'kind' : 'l', 'filename' : '%s', 'cmd' : '%d' }" % (loc[0],loc[1]))
EOF
endif
return result
endfunction

" Get the correct tag information for the identifier the cursor position
function s:GetCorrectTag(start)
  let result = {}

  try

  let token = omni#cpp#utils#TokenizeCurrentInstructionUntilWord()
    let items = omni#cpp#items#Get(token)
    let contextStack = omni#cpp#namespaces#GetContexts()
  let tag_is_file = 0
  let ident = expand("<cword>")

  if token[0].value == '#' && token[1].value == 'include'
    " in case of #include directive, take the full file name not just the
    " token
    let tag_is_file = 1
    let ident = expand("<cfile>")
  elseif items == []
    for type in contextStack
      if type == '::'
        break
      endif
      let result = s:FindTagInfo(type, ident, a:start)
    endfor
  else
    let typeInfo = omni#cpp#items#ResolveItemsTypeInfo(contextStack, items)
    if typeInfo != {}
      let type = typeInfo.value

      if type(type) == type("")
        for taginfo in taglist('^\C'. type. "$")
          if(taginfo.name == type) && has_key(taginfo, 'typeref')
            let type = substitute(taginfo.typeref, '[^:]*:','', '')
            break
          endif
        endfor
      elseif has_key(type, 'typeref')
        let x = type.typeref
        unlet type
        let type = substitute(x, '[^:]*:','', '')
      endif
      let result = s:FindTagInfo(type, ident, a:start)
    endif
  endif

  if result == {}
    let StartCount = a:start
    let Count = 0
    for taginfo in taglist('^\C' . ident . "$")
      let Count = Count + 1
      if taginfo.kind == "m"
        continue
      endif
      if(StartCount)
        let StartCount = StartCount - 1
      else
        let result = taginfo
        if tag_is_file
          " if tag is a file - don't go to the first line
          " just be in the last accessed location
          let result.cmd = ''
        endif
        break
      endif
    endfor
  endif

  if result == {}
    let cur_pos = getpos(".")
    if searchdecl(ident, StartCount) == 0
      let result = {'kind' : 'l', 'filename' : expand("%"), 'cmd' : line(".") }
      call setpos(".", cur_pos)
    endif
  endif

  catch
    echo "Error in cppnav plugin"
  endtry

  return result
endfunction

" jump back to the original location
"
function JumpBackFromTag()
  if len(s:tag_stack) > 0
    let pos = remove(s:tag_stack, -1)
    call s:GotoFileTab(pos[1], &modified)
    call winrestview(pos[2])
  endif
endfunction

function s:GotoFileTab(fname, newtab)
  let buf_number = bufnr(a:fname)

  " We are already in the same buffer
  if buf_number == bufnr("%")
    return
  endif

  " tab navigation is disabled
  if g:cppnav_tab == 'never'
    exe "silent " . "edit " . a:fname
    return
  endif

  let index = -1
  let empty_buf = -1
  let empty_tab = -1

  if buf_number != -1
    for i in range(tabpagenr("$"))
      let tab_file_list = tabpagebuflist(i + 1)
      let index = match(tab_file_list, "^" . buf_number . "$")
      if index != -1
        break
      endif
      " also remember the fist empty buffer
      if empty_buf == -1
        for buf_nr in tab_file_list
          if bufname(buf_nr) == "" &&
                \ getbufvar(buf_nr, '&modified') == 0 &&
                \ getbufvar(buf_nr, '&buftype') == ""
            let empty_buf = buf_nr
            let empty_tab = i + 1
          endif
        endfor
      endif
    endfor
  endif

  if index != -1
    let tabnum = i+1
    if tabnum != tabpagenr()
      exe "tabn " . tabnum
    endif
    exe bufwinnr(buf_number) . "wincmd w"
  else
    if a:newtab == 1 || g:cppnav_tab == 'always'
      " if tab not found create a new tab
      if empty_buf == -1
        exe "tabe " . a:fname
      else
        " if there is an empty buffer use that instead
        exe "tabn " . empty_tab
        exe bufwinnr(empty_buf) . "wincmd w"
        exe "edit " . a:fname
      endif
    else
      " newtab == 0 so edit it in the same window
      exe "silent " . "edit " . a:fname
    endif
  endif
endfunction

function s:ClosePreview()
  nunmap <ESC>
  pclose
endfunction

" jump to the declaration of the identifier under the cursor
function JumpToTag(tcount, prev, jump)
  " don't do that in preview window
  if &previewwindow
    return 0
  endif

  " Get the identifier under the cursor
  let ident = expand("<cword>")

  " if count == -1 use alternate function
  if a:tcount == -1
    let taginfo = s:GetCorrectTagAlt()
  else
    let taginfo = s:GetCorrectTag(a:tcount)
  endif

  if taginfo == {}
    echo "No match found"
    return 0
  else
  try
    if a:prev == 1
      " supress the error display while opening the currently
      " modified file in preview window
      try
        exe "silent " . "pedit " . taginfo.filename
      catch
      endtry

      let edit_win = winnr()
      wincmd P
      "nnoremap <silent> <ESC> :call <SID>ClosePreview()<CR>
    else
      if a:tcount <= 0
        call add(s:tag_stack, [ident, expand("%"), winsaveview()])
      endif
      call s:GotoFileTab(taginfo.filename, &modified)
    endif

    let cmd = escape(taginfo.cmd, '*.+?[]')
    let found = 0
    if cmd != ''
      if strpart(cmd,0,1) == '/'
        call search(strpart(cmd,1,strlen(cmd)-2))
      else
        exec 'silent ' . cmd
      endif
      let found = search(ident, 'cw')
    endif
    if &previewwindow && a:jump == 0
      if found != 0
        call HlExpression(ident)
        redraw
      endif
      exe edit_win . "wincmd w"
    endif
    return 1
  catch
    echo "Unable to jump ! try saving the file."
    return 0
  endtry
  endif
endfunction

function! s:FunctionOpen()
  let old_col = col('.')
  let cline = getline('.')
  let cline = strpart(cline, 0, old_col - 2)
  let column = match(cline, '\<[a-zA-Z_][a-zA-Z0-9_]*$')

  if column >= 0
    call setpos('.', [0, line('.'), column, 0])
    let taginfo = s:GetCorrectTag(0)
    if taginfo != {}
      echo strpart(taginfo.cmd, 2, len(taginfo.cmd) - 4)
    endif
  endif

  return '('
endfunction

" show prototype of the identifier under the cursor
function ShowPrototype()
  if JumpToTag(0, 1, 1) == 1
    let line = getline(".")
    pclose
    echo line
  endif
endfunction

function NestedJumpToTag(prev, jump)
  let ident = expand("<cword>")

  if len(s:tag_stack) > 0 && s:tag_stack[-1][0] == ident
    let s:tag_nest_count = s:tag_nest_count + 1
  else
    let s:tag_nest_count = 0
  endif

  call JumpToTag(s:tag_nest_count, a:prev, a:jump)
endfunction

" highlight the given expression
function HlExpression(exp)
  autocmd WinEnter <buffer> match none
  call search(a:exp, 'c')
    exe 'match Search "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
endfunction

" Highlight Current Line
function HlCurrentLine()
  autocmd WinEnter <buffer> match none
  exe 'match Search /\%'.line(".").'l.*/'
endfun

" map the keys for quick navigation
function! s:SetupMapping()
  nnoremap <buffer> <silent> <Space>  :<C-U>call ShowPrototype()<CR>
  nnoremap <buffer> <silent> _    :<C-U>call NestedJumpToTag(1, 1)<CR>
  nnoremap <buffer> <silent> -    :<C-U>call NestedJumpToTag(1, 0)<CR>
  nnoremap <buffer> <silent> <C-]>  :<C-U>call NestedJumpToTag(0, 0)<CR>
  nnoremap <buffer> <silent> ]<C-]> :<C-U>call JumpToTag(-1, 0, 0)<CR>
  nnoremap <buffer> <silent> <C-t>  :<C-U>call JumpBackFromTag()<CR>
  inoremap <buffer> <silent> (    <C-O>:call ShowPrototype()<CR>(

  " autocmd BufWrite <buffer> call CodeCleanup()
endfunction

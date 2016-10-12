"
" File type specific settings and autocommands
"
scriptencoding utf-8

augroup LocalAutocommands
  au!

  " Set the current working directory when launching vim
  autocmd VimEnter * silent! lcd %:p:h

  " Auto-reload vim configs
  "au BufWritePost .vimrc,vimrc,*vim/configs/?* source %

  " Reload xresources on save
  au BufWritePost xresources silent! exec '!$LOCAL_ETC/xorg/xrdb_reload'

  " Reload sxhkd on save
  au BufWritePost sxhkdrc silent! exec '!$LOCAL_ETC/sxhkd/reload'

  if !exists("g:rtrim_whitespace_on_save") || g:rtrim_whitespace_on_save == 1
    au BufWritePre * :%s/\s\+$//e
  endif

  " Return to last edit position when opening files
  au BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

  " Create syntax directives to replace the fugly default foldmarker
  " au Syntax * syntax match FoldMarkerStart /\v(# |#)?\{\{\{/ conceal cchar=⯈
  " au Syntax * syntax match FoldMarkerStop  /\v(# |#)?\}\}\}/ conceal cchar=$
  au Syntax * syntax match FoldMarkerStart /\v(# ?|" ?|\/\* ?|\/\/ ?|; ?)?\{\{\{/ conceal cchar=⯈
  au Syntax * syntax match FoldMarkerStop  /\v(# ?|" ?|\/\/ ?|; ?)?\}\}\}( ?\*\/)?/ conceal cchar=$
  au Syntax * syntax cluster FoldMarker contains=FoldMarkerStart,FoldMarkerStop

  " Apply to existing groups
  au Syntax * syntax cluster cCommentGroup add=@FoldMarker
  au Syntax * syntax cluster shCommentGroup add=@FoldMarker
  au Syntax * syntax cluster vimCommentGroup add=@FoldMarker
  au Syntax * syntax cluster dosiniComment add=@FoldMarker

  " Default coloring
  " hi default link FoldMarker Comment
  hi default link FoldMarker vimHiClear

  " Foldmarker preview {{{
  "
  " One-liner {{{ }}}
  "
  " }}}

augroup END

" vim:foldmethod=marker

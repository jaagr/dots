
" Dynamically set format options, depending on where you are in a
" mail, idea from Teemu Likonen:
" http://groups.google.com/group/vim_use/msg/f59e5c1adc6be2b3

let d_fo = &fo
let s:defaults = 'setlocal tw=72 ts=8 sts=4 sw=4 fo='.d_fo
execute s:defaults
let b:MailAreaDetect=1

"nnoremap <buffer> <LocalLeader>ma1 :call <SID>MailAreaDetect_On()
"    \ <bar> echo 'MailAreaDetect On'<CR>
"nnoremap <buffer> <LocalLeader>ma0 :call <SID>MailAreaDetect_Off()
"    \ <bar> echo 'MailAreaDetect Off'<CR>

nnoremap <buffer><silent> <F9> :call <SID>MailAreaDetect_Switch(0)<CR>
inoremap <buffer><silent> <F9> <C-\><C-O>:call <SID>MailAreaDetect_Switch(1)<CR>

function! s:MailAreaDetect_Switch(vmode)
    if b:MailAreaDetect
        silent call <SID>MailAreaDetect_Off()
        let b:MailAreaDetect=0
        echo 'MailAreaDetect Off'
        if a:vmode
            sleep 1
        endif
    else
        silent call <SID>MailAreaDetect_On()
        let b:MailAreaDetect=1
        echo 'MailAreaDetect On'
        if a:vmode
            sleep 1
        endif
    endif
endfu


function! s:MailAreaDetect_On()
    silent autocmd! MailAreaDetect CursorMoved,CursorMovedI
                \ <buffer> call <SID>AreaOptions()
    let b:MailAreaDetect=1
endfunction

function! s:MailAreaDetect_Off()
    silent autocmd! MailAreaDetect
    execute s:defaults
    let b:MailAreaDetect=0
endfunction

augroup MailAreaDetect
    autocmd!
    call <SID>MailAreaDetect_On()
augroup END

function! s:AreaOptions()
    execute s:defaults
    if <SID>CheckArea('\v^From( |: ).*\n','\v^$')
        "echo 'Header'
        setlocal fo-=a fo-=w fo-=t sts=0 sw=8 noet
    elseif getline('.') =~ '\m^\s*>'
        "echo 'Quotation'
        setlocal fo-=a fo-=w
    elseif <SID>CheckArea('\m^--- .*\n^+++ ','\v(^$|\n^-- $)')
        "echo 'Patch'
        setlocal fo-=a fo-=w fo-=t sts=0 sw=8 noet
    elseif <SID>CheckArea('^-- $','^$')
        "echo 'Signature'
        setlocal fo-=a fo-=w fo-=t sts=0 sw=8 noet
    else
        "echo 'My text'
        setlocal fo+=aw et
    endif
endfunction

function! s:CheckArea(start, end)
    return (search(a:start,'bcnW')-line('.')) >
                \ (search(a:end,'bnW')-line('.'))
endfunction

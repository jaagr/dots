"  This vim-Script is used for editing mails
"
"  First let's have some configuration variables:

" If you want, to have the quoted Signature automatically removed, set
" this variable to 1
" This function is by default bound to <leader>mdq
let g:DeleteQuotedSignature=1
" Or use
" map <leader>dqs call DeleteQuotedSig<CR>

" If you want to have Old Subject lines automatically removed, set the
" following variable to 1
" This function is by default bound to <leader>mds
let g:DeleteOldSubject=1

" You can clean the subject of the annoying parts "RE", "AW" or "(was: ...)"
" automatically by setting this variable to 1.
" The function is by default bound to <leader>mcs
let g:CleanSubject=1

" You can automatically put a Greeting string into the message by setting
" this variable to 1. Note you have to initialize the variables b:Signoff (for
" the Signoff string) and b:Name (for your name) in order to have it working.
" Also note that there is no key mapping done for that function by default
let g:SignOff=1

" If you want to switch the topic of the mail, use the function
" ChangeSubject() which is by default bound to <leader>mct

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" First initialize the variables
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"if !exists(g:DeleteQuotedSignature)
"    let s:DeleteQuotedSignature=0
"else
"    let s:DeleteQuotedSignature=g:DeleteQuotedSignature
"endif
"
"if !exists(g:DeleteOldSubject)
"    let s:DeleteOldSubject=0
"else
"    let s:DeleteOldSubject=g:DeleteOldSubject
"endif
"
"if !exists(g:CleanSubject)
"    let s:CleanSubject=0
"else
"    let s:CleanSubject=g:CleanSubject
"endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Let's first start with the mappings of the functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <leader>mdq :call DeleteQuotedSig()<CR>
map <silent> <leader>mds :call DeleteOldSubject()<CR>
map <silent> <leader>mct :call CleanSubject2()<CR>:call ChangeSubject()<CR>
map <silent> <leader>mcs :call CleanSubject()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Let's first start with the mappings of the functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Delete quoted Signature
function! DeleteQuotedSig()"{{{
    if search('^[|> ]\+-- $') != 0
	g/^[|> ]\+-- $/normal d}
    endif
    if search('^[|> ]\+--$')!=0
	g/^[|> ]\+--$/normal d}
    endif
endfunc"}}}

" Delete old Subject line
function! DeleteOldSubject()"{{{
    " store old search register
    let s:oldSearch=@/

    " Search for the Subject Line
"    let @/ = "^\(Subject: \)\(Re: \|An: .*\)\((was\|r: .*)\)$"
    "let @/="^\\(Subject: \\)\\(Re: \\|AW: \\)*\\([^(]*\\)\\( (wa\\%(s\\|r\\): .*)\\)$"
    "let @/="^\\(Subject: \\)\\(\\%([rR][eE]\\)\\|\\%([aA][wW]\\): \\)\\(\\%([rR][eE]\\)\\|\\%([aA][wW]\\): \\)\+\\([^(]*\\)\\( (wa\\%(s\\|r\\): .*)\\)$"
    let @/="^\\(Subject: \\)\\(.\\{-}\\) (wa\\%(s\\|r\\): .*)$"

    :if search(@/) != 0
	s//\1\2\4/
    :endif

    " restore search register
    let @/=s:oldSearch
endfunc"}}}

" Change Subject
function! ChangeSubject()"{{{
    let l:origCursor=line('.')
    call cursor(1,0)
    let l:lineNum=search("^Subject: ")
    let l:origSubj=getline(l:lineNum)
    if has("gui")
	let l:newSubject=inputdialog("Enter new Subject: ")
    else
	let l:newSubject=input("Enter new Subject: ")
	echo ""
    endif
    if l:newSubject != ""
	call DeleteOldSubject()
	let l:oldSubject="^\\(Subject: \\)\\(.*\\)$"
	let iNewSubject=substitute(l:origSubj,l:oldSubject,"\\1".l:newSubject." (was: \\2)","")
	call setline(l:lineNum, iNewSubject)
    endif
    call cursor(l:origCursor, 0)
endfunc"}}}

" Set Signoff-String
function! Signoff(Signoff,Name)"{{{
    if (search("^-- $") == 0)
	call cursor(9999999,0)
    else
	-1
    endif
    let curLine=getline(".")
    if (curLine != a:Name)
	if  version>=700
	    call append(line("."),[a:Signoff,a:Name])
	else
	    call append(line("."),a:Name)
	    call append(line("."),a:Signoff)
	endif
    endif
endfunc"}}}

function! CleanSubject()"{{{
    let l:origLine=line('.')
    let l:origCol=col('.')
    call cursor(1,0)
    if search("^Subject: ") != 0
	let l:origSubj=getline(".")
	let l:pattern="\\%(\\%([Rr][Ee]\\)\\|\\%([Aa][Ww]\\)\\)\\[\\=[1-9]\\=\\]\\=: \\="
	" First Get Rid of all RE/AW
	let l:NewSubject=substitute(l:origSubj,l:pattern,"","g")
	if l:NewSubject !=# l:origSubj
	    " Now insert one single Re: if we have previously removed them
	    let l:NewSubject=substitute(l:NewSubject,"^\\(Subject: \\)","\\1Re: ","")
"	    call setline(".",l:NewSubject)
	endif
	call setline(".",l:NewSubject)
    endif
    call cursor(l:origLine,l:origCol)
endfunc"}}}

" Enable Attaching of files using :Attach
function! Attach(Filename)"{{{
    normal magg}-
    let list =[]
    for line in readfile(a:Filename)
	let list+=['Attach: '.line]
    endfor
    call append(line('.'), list)
    normal `a
endfunction"}}}

function! CleanSubject2()"{{{
    let l:origLine=line('.')
    let l:origCol=col('.')
    call cursor(1,0)
    if search("^Subject: ") != 0
	let l:origSubj=getline(".")
"	let l:pattern="\\%(\\%([Rr][Ee]\\)\\|\\%([Aa][Ww]\\)\\)\\[\\=[1-9]\\=\\]\\=: \\="
	let l:pattern="\\%(\\%([Rr][Ee]\\)\\|\\%([Aa][Ww]\\)\\|\\%([Ff][Ww]\\)\\)\\[\\=[1-9]\\=\\]\\=: \\="
	" First Get Rid of all RE/AW
	let l:NewSubject=substitute(l:origSubj,l:pattern,"","g")
	call setline(".",l:NewSubject)
    endif
    call cursor(l:origLine,l:origCol)
endfunc"}}}

if exists("g:CleanSubject") && g:CleanSubject==1
    call CleanSubject()
endif
"if s:DeleteQuotedSignature==1
if exists("g:DeleteQuotedSignature") && g:DeleteQuotedSignature==1
    call DeleteQuotedSig()
endif

"if s:DeleteOldSubject==1
if exists("g:DeleteOldSubject") && g:DeleteOldSubject==1
    call DeleteOldSubject()
endif



if exists("b:Signoff") && exists("b:Name") && exists("g:SignOff") && g:SignOff==1
    call Signoff(b:Signoff,b:Name)
endif
"call DeleteOldSubject()
call cursor(1,1)
call search("^$")


command! -nargs=1 -complete=file AttachList :call Attach("<args>")
command! -nargs=1 -complete=file AttachFile exe "normal magg}-" | call append(line('.'), 'Attach: <args>') | normal `a

" vi:foldmethod=marker:foldenable:foldlevel=0:

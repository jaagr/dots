"
" Keybindings
"

" General: {{{

let g:mapleader = ","

map <leader>l :so <c-r>=expand("$HOME/.vimrc")<cr><cr>

" Faster maps
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
nmap <leader>Q :qall<cr>
nnoremap ; :
imap jj <esc>

" Treat long lines as break lines
map j gj
map k gk

" Paragraph formatting
vmap Q gq
nmap Q gqap

" Change pwd of current buffer and prompt for file to edit
map <leader>s :lcd %:p:h<cr>:new <c-r>=expand("%:p:h")<cr>/
map <leader>v :lcd %:p:h<cr>:vnew <c-r>=expand("%:p:h")<cr>/
map <leader>e :lcd %:p:h<cr>:edit <c-r>=expand("%:p:h")<cr>/

" Prepend/append line
nmap <c-x><c-k> m'O<esc>''k
nmap <c-x><c-j> m'o<esc>''j

" Toggle line wrapping
nmap <leader><c-w> :set wrap!<cr>

" Get rid of the default K (never use the feature)
map K <Nop>

" }}}
" Windows: {{{

nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>

" TODO: Finish this
" func! WindowResize(x, y)
"   let l:nr = winnr()
"
"   if winnr('$') == nr
"     return
"   endif
"
"   let l:x = a:x
"   let l:y = a:y
"
"   let l:width = winwidth(nr)
"   let l:height = winheight(nr)
"
"   let l:fullwidth = &columns
"   let l:fullheight = &lines
"
"   if abs(x) && (width == fullwidth || width == 1)
"     echo "Already full-width horizontally"
"     let x = 0
"   endif
"
"   if abs(y) && (height == fullheight || height == 1)
"     echo "Already full-height horizontally"
"     let y = 0
"   endif
"
"   echo x
"   echo width
"   echo fullwidth
" endfunc
" " nnoremap <silent> <up> :call WindowResize(0, 3)<cr>
" nnoremap <silent> <up> :call WindowResize(3, 3)<cr>
" nnoremap <silent> <down> :call WindowResize(0, -3)<cr>
" nnoremap <silent> <left> :call WindowResize(-3, 0)<cr>
" nnoremap <silent> <right> :call WindowResize(3, 0)<cr>
" nnoremap <down> :execute "resize " . (winheight(0) * 3/2)<cr>
" nnoremap <left> :execute "vertical resize " . (winwidth(0) * 3/2)<cr>
" nnoremap <right> :execute "vertical resize " . (winwidth(0) * 2/3)<cr>

" nnoremap <up> :execute "resize " . (winheight(0) * 2/3)<cr>
" nnoremap <down> :execute "resize " . (winheight(0) * 3/2)<cr>
" nnoremap <left> :execute "vertical resize " . (winwidth(0) * 3/2)<cr>
" nnoremap <right> :execute "vertical resize " . (winwidth(0) * 2/3)<cr>

" nnoremap + :exe "resize " . (winheight(0) * 3/2)<CR>
" nnoremap - :exe "resize " . (winheight(0) * 2/3)<CR>

" }}}
" Buffers: {{{

" nmap <leader>1 :b1<cr>
" nmap <leader>2 :b2<cr>
" nmap <leader>3 :b3<cr>
" nmap <leader>4 :b4<cr>
" nmap <leader>5 :b5<cr>
" nmap <leader>6 :b6<cr>
" nmap <leader>7 :b7<cr>
" nmap <leader>8 :b8<cr>
" nmap <leader>9 :b9<cr>

" Show all open buffers and their status
nmap <leader>bl :ls<cr>

" Cycle buffers
nmap <tab> :bnext<cr>
nmap <s-tab> :bprevious<cr>

" Toggle between the most recent buffer/file
nmap <leader>` :e#<cr>:pwd<cr>

" Close the current buffer
nmap <leader>bd :Bclose<cr>

" Close the current buffer and move to the previous one
nmap <leader>bq :bp <bar> bd #<cr>

" Switch CWD to the directory of the current buffer
nmap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" }}}
" Tabs: {{{

" Cycle tabs
nmap <leader>tn :tabnext<cr>
nmap <leader>tp :tabprevious<cr>

" Close the current tab
nmap <leader>td :tabclose<cr>

" }}}
" Search: {{{

map <space> /
map <c-space> ?

" Clear match highlights
nmap <silent> <leader><leader> :nohlsearch<cr>

" Search for selected text
vmap <silent> * y<bar>:let @/ = substitute(@", "\n", "", "")<cr>n
vmap <silent> # *#

" Replace all occurrences of selection
vmap <silent> <leader>r mx:call VisualReplace()<cr>

" Replace selection with results from echo
" useful when replacing \uxxxx with unicode symbol
vmap <silent> <leader>u vgvy:let @/ = system("echo -n <c-r>"")<cr>gvxa<c-r>/<esc>:nohlsearch<cr>

" Show results in quickfix window
map <leader>co :botright cope<cr>

" Cycle results
map <leader>cn :cn<cr>
map <leader>cp :cp<cr>

" Grep pwd/file
map <leader><space><space> :vimgrep // <c-r>%<c-b><right><right><right><right><right><right><right><right><right>
map <leader><space> :vimgrep // **/*<left><left><left><left><left><left>

" }}}
" Predefined Macros: {{{

" Create a wrapping fold around current function
" nmap <leader>] O<esc>Vj$h%:fold<cr>zaa Title jj0j$%a<cr><cr>jja <esc>h2k%0O<esc>kza
let @f = "OVj$h%:foldzaa Title jj0j$%ajja h2k%0Okza"

" Create tight fold around current function
" nmap <leader>[ V$h%:fold\za$4ha jj$%a jj0%0za
let @g = "V$h%:fold\za$4ha jj$%a jj0%0za"

" }}}
" External tools: {{{

" Compile and run
nmap <f7> :lcd %:p:h<cr>:!make<cr>
nmap <f8> :lcd %:p:h<cr>:!make && ./%< <cr>

nmap <f9> :SyntasticCheck<cr>:echo 'Syntastic check done'<cr>
" nmap <f10> :loader eclim

" Execute script in terminal
nnoremap <leader>0 :w<cr>:silent !set -o pipefail; clear
\ ; echo -e "\x1B[0m\x1B[33mRunning script: $(pwd)/%\x1B[0m"
\ ; echo -e "\x1B[40m   \x1B[0m\x1B[0m"
\ ; [ -x "./%" ] && ./% 2>&1 \| sed -e 's/.*/\x1B[40m   \x1B[0m   \0/'
\ ; code=$?
\ ; echo -e "\x1B[40m   \x1B[0m\x1B[0m\x1B[0m"
\ ; ([ $code -eq 0 ] &&
\   printf '[\x1B[32mOK\x1B[0m] script finished successfully' \|\|
\   printf '[\x1B[31mERR\x1B[0m] script failed (exit code: \%d)' $code)
\ ; read -s<cr>
\ :redraw!<cr>

" }}}
" Spell Checking: {{{

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Cycle misspelled words
map <leader>sn ]s
map <leader>sp [s

" Whitelist word
map <leader>sa zg

" List suggestions
map <leader>s? z=

" }}}

" Plugin: Buffergator ----- TODO: Update keymaps {{{

let g:buffergator_viewport_split_policy = 'R'
let g:buffergator_suppress_keymaps = 1

nmap <leader>go :BuffergatorToggle<cr>
nmap <leader>gp :BuffergatorMruCyclePrev<cr>
nmap <leader>gn :BuffergatorMruCycleNext<cr>

" }}}
" Plugin: CtrlP {{{

" Default CtrlP mapping is set by the plugin itself
" and the variable is defined in plugins.vim

nmap <leader>f :CtrlP /home/jaagr/<cr>
nmap <leader>p :CtrlPMRU<cr>
nmap <leader>b :CtrlPBuffer<cr>

" }}}
" Plugin: NerdTree {{{

func! NerdTREEProximity() " {{{
  " Write a function that opens NerdTREE on the side
  " closest to the current buffer
endfunc

" }}}

map <leader>o :silent! NERDTreeFind<cr>

" }}}
" Plugin: Tagbar {{{

" Toggle the display of the Tagbar window
nmap <leader>tt :TagbarToggle<cr>
nmap <leader>to :TagbarOpenAutoClose<cr>

" }}}
" Plugin: Syntastic {{{

nmap <f6> :SyntasticCheck<cr>

" }}}
" Plugin: Airline {{{

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

"}}}
" Plugin: SnipMate {{{

" imap <leader><leader> <esc>a<Plug>snipMateNextOrTrigger
" smap <leader><leader> <Plug>snipMateNextOrTrigger
" imap <leader><tab> <esc>a<Plug>snipMateNextOrTrigger
" smap <leader><tab> <Plug>snipMateNextOrTrigger

" }}}
" Plugin: UltiSnips {{{

let g:UltiSnipsExpandTrigger="<leader><cr>"
let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"

" }}}
" Plugin: Goyo+Zen room {{{

nnoremap <silent> <leader>z :Goyo<cr>

" }}}
" Plugin: a.vim {{{

"func! AVimBindings()
"  nmap <silent> <leader>af :A<cr>
"  nmap <silent> <leader>ao :A<cr>
"  nmap <silent> <leader>as :AS<cr>
"  nmap <silent> <leader>av :AV<cr>
"  nmap <silent> <leader>a] :AN<cr>
"endfunc

" }}}
" Plugin: vcoolor.vim {{{

let g:vcoolor_disable_mappings = 1
let g:vcoolor_map = '<leader>c'

" }}}
" Plugin: fswitch.vim {{{

"func! FSwitchBindings()
"  " buffer
"  nmap <silent> <leader>af :FSHere<cr>
"  " split below
"  nmap <silent> <leader>as :FSSplitBelow<cr>
"  " split right
"  nmap <silent> <leader>av :FSSplitRight<cr>
"endfunc

" }}}

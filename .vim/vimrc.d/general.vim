"
" General configuration
"

scriptencoding utf-8

set directory=$XDG_CACHE_HOME/vim

" Allow execution of directory specific .vimrc
set exrc

" Improve responsiveness of plugins that depend on this
set updatetime=800

" Lines of history to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

set nobackup
set nowritebackup
set noswapfile

set expandtab
set smarttab
set shiftwidth=2
set tabstop=2

set autoindent
set smartindent
set nowrap

set linebreak
set textwidth=80

" Do not auto-wrap text
set formatoptions-=t

" More natural split's
set splitbelow
set splitright

set mouse=v
"set mousemodel=extend

if $DISPLAY
  set clipboard=unnamedplus
endif

set wildmenu
set wildmode=list:longest:list,full
set wildignore=*.o,*~,*.pyc,*.swp,*.zip,*.rar,*.png,*.jpg,*.wav,*.mp3,*.avi,*.cpan*

" Always show current position
set ruler

set cmdheight=1
set cmdwinheight=4

set winwidth=25
set winheight=15

" A buffer becomes hidden when it is abandoned
set hidden

" Configure backspace so it acts normal
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search
set ignorecase
set smartcase
set hlsearch
set incsearch

" Don't redraw while executing macros for performance reasons
"set lazyredraw
" XXX: sometimes causes the viewport to go blank in neovim
set nolazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
"set showmatch
" XXX: causes lag in neovim
set noshowmatch

" How many tenths of a second to blink when matching brackets
set matchtime=9

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

set foldcolumn=0
set foldmethod=marker
set foldtext=NeatFoldText()

set fillchars=vert:│,fold:-

" Conceal with replacement chars
set conceallevel=1
set concealcursor=nv

" XXX: Plug 'ConradIrwin/vim-bracketed-paste' replaces the need for this
"set pastetoggle=<f4>

set scrolloff=7

set fileformats=unix,dos,mac

" Neovim complains about setting encoding after startup
" if I reload the configs, so lets just skip it
if !has("nvim")
  set encoding=utf8
endif

" Always show the status line
set laststatus=2

" Show line numbers relative to the current cursor position
set number
set relativenumber

" Display tabs as dashes instead of ^I
set listchars=tab:>-
set list

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Remember info about open buffers on close
set viminfo^=%

" Remap vim 0 to first non-blank character
map 0 ^

" Use the platinum searcher over grep
if executable('pt')
  set grepprg=pt\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c:%m
endif

" Load default tags
set tags+=$HOME/.vim/tags/c
set tags+=$HOME/.vim/tags/cpp

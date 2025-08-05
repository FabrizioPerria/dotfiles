colorscheme habamax
let mapleader = " "
set guicursor=n-v-c:block-blinkwait1000-blinkon100-blinkoff50,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20
set cursorline
set number
set hlsearch
syntax on
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set textwidth=120
set wrap
set swapfile
set nobackup
set nowritebackup
if has("unix")
    set undodir=$HOME/.vim/undodir
else
    set undodir=$LOCALAPPDATA/.vim/undodir
endif
set incsearch
set scrolloff=10
set sidescrolloff=8
set signcolumn=yes
set showmatch
set matchtime=2
set lazyredraw
set isfname+=@-@
set hidden
set noerrorbells
set backspace=indent,eol,start
set iskeyword+=-
set path+=**
set selection=exclusive
set autoread
set noautowrite
set updatetime=10
set colorcolumn=120
set foldmethod=expr
set foldlevel=99
set encoding=utf-8
set autoindent
set fileformat=unix
set listchars=eol:_,tab:→→,trail:~,space:·
set list
set mouse=

highlight NonText guifg=#6f87af guibg=NONE ctermbg=NONE
highlight ColorColumn ctermbg=236 guibg=#2c2c2c
highlight CursorLine guibg=#232323
highlight Visual guibg=#444444 ctermbg=236
highlight Special guifg=#ffffff guibg=NONE ctermbg=NONE
hi clear SpellBad
hi SpellBad cterm=underline

nnoremap J mzJ`z
nnoremap <leader>bv :vsplit<CR>
nnoremap <leader>bh :split<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap <M-h> 10<C-w><
nnoremap <M-j> 10<C-w>-
nnoremap <M-k> 10<C-w>+
nnoremap <M-l> 10<C-w>>
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
nnoremap Y yy
nnoremap <leader>fe :E<CR>
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y

nnoremap <C-d> <C-d>zz
xnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
xnoremap <C-u> <C-u>zz

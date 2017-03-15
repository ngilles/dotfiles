
"Lose compatibility with old vi
set nocompatible

"Make ',' the leader key, easier to reach that '\'
let mapleader=","

filetype off

call pathogen#infect()

"Shortcuts for editing and sourcing .vimrc
nmap <silent> <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

filetype plugin indent on
syntax on

set modelines=0

"Tab preferences
set tabstop=4
set shiftwidth=4
set shiftround
set softtabstop=4
set expandtab
set autoindent

set encoding=utf-8

"Keep 3 rows and 8 columns in view
set scrolloff=3
set scroll=1
set sidescrolloff=8
set sidescroll=1

set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set nowrap

if version >= 703
    set colorcolumn=80
endif

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

"Set search params
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

"Strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

"Allow escaping input mode faster than reaching for ESC
inoremap jj <ESC>

set wildignore=*.swp,*.bak,*.pyc,*.class,*.o
set nobackup
set noswapfile

if has("gui_running")
    colorscheme mustang
    set guifont=Monospace\ 8
else
    if &t_Co >= 256
        colorscheme mustang
    endif
    set mouse=a
    set title
endif

"In case we forgot sudo when editing root config files
cnoremap w!! w !sudo dd of=%


" from http://github.com/adamhjk/adam-vim
" nicer status line
set laststatus=2
set statusline=
set statusline+=%-3.3n\ " buffer number
set statusline+=%f\ " filename
set statusline+=%h%m%r%w " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%= " right align remainder
set statusline+=0x%-8B " character value
set statusline+=%-14(%l,%c%V%) " line, character
set statusline+=%<%P " file position

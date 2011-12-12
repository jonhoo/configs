 " Pathogen
call pathogen#infect()

 " Get indentation
set autoindent

set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines

" GUI fixes
set ruler " Where am I?
set ttyfast
set laststatus=2

" Indent script and style by one
let g:html_indent_script1 = "inc" 
let g:html_indent_style1 = "inc" 

" Relative line numbers
set relativenumber

" Permanent undo
set undofile

" Autocomplete
set wildmenu
set wildmode=list:longest
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/*~,*/*.png,*/*.jpg,*/*.gif,*/*.settings   " for Linux/MacOSX

" Fix tabs
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Get syntax
syntax on

" Style vim
" colors clouds
set background=dark
colorscheme solarized

" Keymaps
let mapleader = ","
nnoremap <tab> %
vnoremap <tab> %
inoremap <F1> <ESC>
vnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap jj <ESC>

" Good-bye arrow keys... =(
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

" Proper search
set hlsearch      " Highlight search results
set incsearch     " Incremental search
set ignorecase
set smartcase
set gdefault

" Script plugins
au Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim

" Filetype indenting
filetype indent on

" Load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Settings
set nocompatible
set encoding=utf-8
set scrolloff=3
set showmode
set hidden
set nowrap        " Stop wrapping my lines

set showcmd       " Show (partial) command in status line.
set mouse=a       " Enable mouse usage (all modes) in terminals

" Give me a colored column
set colorcolumn=100

" Per-project configs
set exrc
set secure
let g:localvimrc_ask = 0

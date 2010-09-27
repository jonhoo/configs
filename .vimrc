 " Get indentation
set autoindent

set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines

" GUI fixes
set ruler " Where am I?
set ttyfast
set laststatus=2

" Relative line numbers
set relativenumber

" Permanent undo
set undofile

" Autocomplete
set wildmenu
set wildmode=list:longest

" Fix tabs
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Get syntax
syntax on

" Style vim
colors clouds

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
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault

" Script plugins
au Filetype html,xml,xsl,php source ~/.vim/scripts/closetag.vim
au Filetype html,xml,css,php source ~/.vim/scripts/zencoding.vim

" Filetype indenting
filetype indent on

" Load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Settings
set nocompatible
set modelines=0
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden

set showcmd       " Show (partial) command in status line.
set mouse=a       " Enable mouse usage (all modes) in terminals

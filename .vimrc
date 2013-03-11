 " Pathogen
call pathogen#infect()

 " Get indentation
set autoindent

set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
let javaScript_fold=0
set foldmethod=marker

" GUI fixes
set ruler " Where am I?
set ttyfast
set laststatus=2

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

" Indent script and style by one
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

let g:Powerline_symbols = 'unicode'
let g:Powerline_colorscheme = 'skwp'
let g:ctrlp_root_markers = ['.lvimrc']

" Relative line numbers
set relativenumber

" Permanent undo
set undodir=~/.vimdid
set undofile

" Autocomplete
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
" Needed since we cannot block .git in wildignore for fugitive: https://github.com/tpope/vim-fugitive/issues/121
let g:ctrlp_custom_ignore = {
  \ 'dir': '\.git$\|\.hg$\|\.svn$\|publish$\|intermediate$',
  \ 'file': '\~$\|\.png$\|\.jpg$\|\.gif$\|\.settings$\|Thumbs\.db\|\.min\.js$\|\.swp\|\.o$\|\.hi$',
  \ }

" Fix tabs
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" No whitespace in vimdiff
set diffopt+=iwhite

" Get syntax
syntax on

" Style vim
" colors clouds
set background=dark
colorscheme solarized
hi Normal ctermbg=NONE
"colorscheme badwolf

" Keymaps
let mapleader = ","
" ,, toggles between buffers
nnoremap <leader><leader> <c-^>
" ,= indents current 'section' (e.g. HTML tag)
nnoremap <leader>> Vat>
nnoremap <leader>< Vat<

" Good-bye arrow keys... =(
nnoremap <up> <nop>
nnoremap <down> <nop>
" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
" Ctrl+C as Esc
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Show those damn hidden characters, but make it easy to turn off
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set list
set listchars=nbsp:¬,extends:»,precedes:«,trail:•
nnoremap <leader><SPACE> :set invlist<cr>

autocmd BufRead *.md set filetype=markdown

" In css files, map D to split one-liners
autocmd BufRead *.css nnoremap D :.s/\({\\|;\)\s*/\1\r/<cr>=%<cr>b>%

" Proper search
set incsearch     " Incremental search
set ignorecase
set smartcase
set gdefault

" Very magic by default
nnoremap / /\v

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
set textwidth=80
set colorcolumn=80

" CtrlP per buffer
nmap ; :CtrlPBuffer<CR>

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Keymap for replacing up to next _ or -
noremap <leader>m ct_
noremap <leader>n ct-

" Leave paste mode when leaving insert mode
au InsertLeave * set nopaste

" Jump to start and end of line using the home row keys
map H ^
map L $

" clipboard!
noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" Jump to last edit position on opening file
autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" Auto-make less files on save
autocmd BufWritePost *.less if filereadable("Makefile") | make | endif

" Per-project configs
set exrc
set secure
let g:localvimrc_ask = 0

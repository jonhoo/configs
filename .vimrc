 " Pathogen
call pathogen#infect()

 " Get indentation
set autoindent

set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
let javaScript_fold=1
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
let g:ctrlp_root_markers = ['.lvimrc']

" Relative line numbers
set relativenumber

" Permanent undo
set undodir=~/.vimdid
set undofile

" Autocomplete
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi
" Needed since we cannot block .git in wildignore for fugitive: https://github.com/tpope/vim-fugitive/issues/121
let g:ctrlp_custom_ignore = '.git,.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi'

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
"colorscheme badwolf

" Keymaps
let mapleader = ","
" ,, toggles between buffers
nnoremap <leader><leader> <c-^> 
" ,= indents current 'section' (e.g. HTML tag)
nnoremap <leader>> Vat>
nnoremap <leader>< Vat<
" ; adds semicolon at the end of the current line if there isn't one
noremap <buffer> ; :s/\([^;]\)$/\1;/<cr>

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing
nnoremap S i<cr><esc><right>

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
" jk as Esc
inoremap jk <Esc>

" Show those damn hidden characters, but make it easy to turn off
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set list
set listchars=nbsp:¬,extends:»,precedes:«,trail:•
nnoremap <buffer> <leader><SPACE> :set invlist<cr>

" In html and php files, map <leader>p to wrap line in <p> tag
autocmd BufRead *.html nnoremap <leader>p :s/^\(\s*\)\(.\+\)/\1<p>\2<\/p>/<cr>
autocmd BufRead *.php nnoremap <leader>p :s/^\(\s*\)\(.\+\)/\1<p>\2<\/p>/<cr>

" In php files, ,s should map to a PHP syntax check
autocmd BufRead *.php nnoremap <leader>s :!php -l %<cr>

" In css files, map D to split one-liners
autocmd BufRead *.css nnoremap D :.s/\({\\|;\)\s*/\1\r/<cr>=%<cr>b>%

" Proper search
set incsearch     " Incremental search
set ignorecase
set smartcase
set gdefault

" Very magic by default
nnoremap / /\v
cnoremap s/ s/\v

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

" I can type :help on my own, thanks.
noremap <F1> <Esc>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Leave paste mode when leaving insert mode
au InsertLeave * set nopaste

" Jump to start and end of line using the home row keys
map H ^
map L $

" Jump to last edit position on opening file
autocmd BufReadPost * if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

" Per-project configs
set exrc
set secure
let g:localvimrc_ask = 0

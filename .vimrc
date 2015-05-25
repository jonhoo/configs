" Fish doesn't play all that well with others
set shell=/bin/bash

" Pathogen
let g:pathogen_disabled = []
if !has('python')
  call add(g:pathogen_disabled, 'ycm')
endif

call pathogen#infect()

" Get indentation
set autoindent

set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
let javaScript_fold=0
set foldmethod=marker " Only fold on marks
set tags=.git/tags
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line

let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

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

let g:ctrlp_root_markers = ['.lvimrc', '.git']
let g:airline_theme = "bubblegum"

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_highlighting = 0
let g:syntastic_javascript_checkers = ['eslint']
inoremap <C-j> :lnext<cr>
nnoremap <C-j> :lnext<cr>
inoremap <C-k> :lprev<cr>
nnoremap <C-k> :lprev<cr>

let g:used_javascript_libs = ''

let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []

" Relative line numbers
set relativenumber

" Sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
" Needed since we cannot block .git in wildignore for fugitive: https://github.com/tpope/vim-fugitive/issues/121
let g:ctrlp_custom_ignore = {
  \ 'dir': '\.git$\|\.hg$\|\.svn$\|publish$\|intermediate$\|node_modules$\|components$',
  \ 'file': '\~$\|\.png$\|\.jpg$\|\.gif$\|\.settings$\|Thumbs\.db\|\.min\.js$\|\.swp\|\.o$\|\.hi$\|.a$\|.sqlite3$\|.key$\|.pub$',
  \ }

" Autocomplete
set completeopt-=preview
" Make space for echodoc
let g:echodoc_enable_at_startup = 1
set cmdheight=2

" racer
let g:racer_cmd = "/usr/bin/racer"
let $RUST_SRC_PATH = "/home/jon/.rust/src"

" Fix tabs
set shiftwidth=8
set softtabstop=8
set tabstop=8
set noexpandtab

" No whitespace in vimdiff
set diffopt+=iwhite

" Get syntax
let mysyntaxfile='~/.vim/doxygen_load.vim'
syntax on

" Style vim
" colors clouds
set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-atelierdune
hi Normal ctermbg=NONE
"colorscheme badwolf

" Keymaps
let mapleader = ","
" ,, toggles between buffers
nnoremap <leader><leader> <c-^>
" ,= indents current 'section' (e.g. HTML tag)
nnoremap <leader>> Vat>
nnoremap <leader>< Vat<
" ; as :
nnoremap ; :

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
" Ctrl+C and Ctrl+J as Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Show those damn hidden characters, but make it easy to turn off
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set nolist
set listchars=nbsp:¬,extends:»,precedes:«,trail:•
nnoremap <leader><SPACE> :set invlist<cr>

autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.trm set filetype=c

" Proper search
set incsearch     " Incremental search
set ignorecase
set smartcase
set gdefault

" YCM
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

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
set colorcolumn=80
" Wrapping options
set formatoptions=tc  " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" CtrlP per buffer
nmap <leader>; :CtrlPBuffer<CR>

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

noremap M :!make -k -j4<cr>

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

" Rust mandates these settings
au Filetype rust source ~/.vim/scripts/spacetab.vim
au Filetype rust set colorcolumn=100

" Per-project configs
set exrc
set secure
let g:localvimrc_ask = 0

let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_bin_path = expand("~/dev/go/bin")

autocmd BufRead,BufNewFile /home/jon/dev/others/biscuit/** let [g:go_fmt_command, g:go_fmt_autosave]=["", 0]

" nvim
if has('nvim')
	runtime! plugin/python_setup.vim
endif

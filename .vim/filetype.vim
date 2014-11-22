augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setfiletype mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setlocal spell tw=72 colorcolumn=73
  " Git commit message
  autocmd Filetype gitcommit                         setlocal spell tw=72 colorcolumn=73
  " Go shortcuts
  au FileType go nmap <leader>t <Plug>(go-test)
  au FileType go nmap <Leader>r <Plug>(go-rename)
  au FileType go nmap <leader>c <Plug>(go-coverage)
augroup END

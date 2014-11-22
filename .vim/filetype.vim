augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setfiletype mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setlocal spell tw=72 colorcolumn=73
augroup END

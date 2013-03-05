augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setfiletype mail
  autocmd BufRead,BufNewFile /tmp/mutt*              set tw=72 colorcolumn=72
augroup END

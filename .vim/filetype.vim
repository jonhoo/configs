augroup filetypedetect
  " Mail
  autocmd BufRead,BufNewFile /tmp/mutt*              setfiletype markdown
  autocmd BufRead,BufNewFile /tmp/mutt*              set tw=72 colorcolumn=72
augroup END

" https://github.com/ms-jpq/coq_nvim snippets
autocmd BufNewFile,BufRead *.snip set filetype=coq-snip
autocmd FileType coq-snip setlocal commentstring=\#\ %s

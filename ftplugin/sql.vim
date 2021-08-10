command! -nargs=* -complete=file SQLFluffLint call sqlfluff#Lint('<q-args>')

nnoremap <silent> <plug>(sqlfluff-lint) :<c-u>call sqlfluff#Lint()<cr>

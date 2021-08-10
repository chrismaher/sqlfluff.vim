function! s:set(dict, key, val)
    if ! empty(a:val)
        let a:dict[a:key] = a:val
    endif
endfunction

function! s:parseDescription(item)
    return matchstr(a:item, '.*|\zs\s.*')
endfunction

function! s:parseLine(line)
    let l:item = {}

    call s:set(l:item, 'lnum', matchstr(a:line, 'L:\s\+\zs\d\+\ze\s\+'))
    call s:set(l:item, 'col', matchstr(a:line, 'P:\s\+\zs\d\+\ze\s\+'))
    call s:set(l:item, 'text', s:parseDescription(a:line))

    " get error number?

    return l:item
endfunction

function! s:parse(lint)
    " remove the header
    " handle with parse failure instead?
    if a:lint[0] =~# '^== '
        call remove(a:lint, 0)
    endif

    let l:qflist = []
    for line in a:lint
        let l:res = s:parseLine(line)

        " generalize this with an argument?
        let l:res.filename = expand('%')

        if has_key(l:res, 'lnum')
            call add(l:qflist, l:res)
        elseif has_key(l:res, 'text')
            " get description and append to previous description
            let l:qflist[-1].text .= l:res.text
        endif
    endfor

    return l:qflist
endfunction

function! sqlfluff#Lint(...)
    " adjust this later to build a quickfix list using the results from multiple arguments
    " let l:fname = a:0 == 0 ? expand('%') : a:1

    let l:lint = split(system('sqlfluff lint ' . shellescape(expand('%'))), '\n')
    let l:parsed = s:parse(l:lint)
    call setqflist(l:parsed)
    execute 'copen'
endfunction

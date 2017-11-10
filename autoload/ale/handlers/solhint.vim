" Author: Brett Sun - https://github.com/sohkai
" Description: Functions for working with solhint, for checking or fixing files.
"
call ale#Set('solidity_solhint_use_global', 0)
call ale#Set('solidity_solhint_executable', 'solhint')

function! ale#handlers#solhint#GetExecutable(buffer) abort
    return ale#node#FindExecutable(a:buffer, 'solidity_solhint', [
    \   'node_modules/solhint/solhint.js',
    \   'node_modules/.bin/solhint',
    \])
endfunction

function! ale#handlers#solhint#Handle(buffer, lines) abort
    " Matches patterns like the following:
    "
    " /path/to/some-filename.sol:47:14: Variable name must be in mixedCase. [Warning/var-name-mixedcase]
    " /path/to/some-filename.sol:56:41: Explicitly mark visibility in function. [Error/func-visibility]
    let l:pattern = '^.*:\(\d\+\):\(\d\+\): \(.\+\) \[\(.\+\)\]$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        let l:type = 'Error'
        let l:text = l:match[3]

        " Take the error type from the output if available.
        if !empty(l:match[4])
            let l:type = split(l:match[4], '/')[0]
            let l:text .= ' [' . l:match[4] . ']'
        endif

        let l:obj = {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'text': l:text,
        \   'type': l:type is# 'Warning' ? 'W' : 'E',
        \}

        call add(l:output, l:obj)
    endfor

    return l:output
endfunction

" Author: Brett Sun - https://github.com/sohkai
" Description: Report errors in Solidity code with solhint

call ale#linter#Define('solidity', {
\   'name': 'solhint',
\   'executable_callback': 'ale#handlers#solhint#GetExecutable',
\   'command': 'solhint -f unix %t',
\   'callback': 'ale#handlers#solhint#Handle',
\})

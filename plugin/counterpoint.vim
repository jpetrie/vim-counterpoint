" counterpoint.vim - File Counterpart Navigation
" Author:  Josh Petrie <http://joshpetrie.com>
" Version: 0.1

if exists("g:loaded_counterpoint")
    finish
endif

let g:loaded_counterpoint = 1

function! s:CounterpointCycle(amount)
    let currentFile = expand("%:t")
    if (strpart(currentFile, 0, 1) == ".")
        " Don't treat the leading dot for invisible files as the
        " beginning of the varying portion of the counterpart name.
        let searchIndex = 1
    else
        let searchIndex = 0
    endif

    let splitIndex = stridx(currentFile, ".", searchIndex)
    if splitIndex == -1
        echo "No counterpart available."
        return
    endif

    let root = strpart(currentFile, 0, splitIndex)
    let counterparts = split(glob(expand("%:h") . "/" . root . ".*"), "\n")
    if len(counterparts) == 1
        echo "No counterpart available."
        return
    endif

    let currentPath = expand("%:p")
    let index = 0
    for counterpart in counterparts
        if currentPath == fnamemodify(counterpart, ":p")
            execute ":edit " . counterparts[(index + a:amount) % len(counterparts)]
            break
        endif
            
        let index += 1
    endfor
endfunc

command! -nargs=0 CounterpointNext :call s:CounterpointCycle(1)
command! -nargs=0 CounterpointPrevious :call s:CounterpointCycle(-1)


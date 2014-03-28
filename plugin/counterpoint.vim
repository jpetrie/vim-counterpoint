" counterpoint.vim - File Counterpart Navigation
" Author:  Josh Petrie <http://joshpetrie.net>
" Version: 0.3

if exists("g:loaded_counterpoint")
    finish
endif

let g:loaded_counterpoint = 1

let s:searchPaths = ["."]
let s:exclusionPatterns = [ ]

function! s:SanitizeList(subject)
    let deduplicated = {}
    for item in a:subject
        let deduplicated[item] = ""
    endfor
    return sort(keys(deduplicated))
endfunc

function! s:AttachPaths(paths, root)
    let results = []
    for path in a:paths
        let results = results + [fnamemodify(simplify(a:root . "/" . path), ":p")]
    endfor
    return results
endfunc

function! s:AddSearchPath(path)
    let s:searchPaths = s:SanitizeList(s:searchPaths + [a:path])
endfunc

function! s:RemoveSearchPath(path)
    let s:searchPaths = s:SanitizeList(filter(s:searchPaths, "v:val != a:path"))
endfunc

function! s:AddExclusionPattern(pattern)
    let s:exclusionPatterns = s:SanitizeList(s:exclusionPatterns + [a:pattern])
endfunc

function! s:RemoveExclusionPattern(pattern)
    let s:exclusionPatterns = s:SanitizeList(filter(s:exclusionPatterns, "v:val != a:pattern"))
endfunc

function! s:IsCounterpartExcluded(counterpart)
    for exclusion in s:exclusionPatterns
        if a:counterpart =~ exclusion
            return 1
        endif
    endfor
    return 0
endfunc

function! s:CycleCounterpart(amount)
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

    let paths = s:AttachPaths(s:searchPaths, expand("%:h"))
    let root = strpart(currentFile, 0, splitIndex)

    " Collect the potential counterparts, filter out anything that matches any
    " supplied exclusion patterns, remove any duplicates, and then cycle.
    let counterparts = split(globpath(join(paths, ","), root . ".*"))
    let counterparts = filter(counterparts, "!s:IsCounterpartExcluded(v:val)")
    let counterparts = s:SanitizeList(counterparts)
    if len(counterparts) <= 1
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

command! -nargs=1 CounterpointAddSearchPath :call s:AddSearchPath(<args>)
command! -nargs=1 CounterpointRemoveSearchPath :call s:RemoveSearchPath(<args>)

command! -nargs=1 CounterpointAddExclusionPattern :call s:AddExclusionPattern(<args>)
command! -nargs=1 CounterpointRemoveExclusionPattern :call s:RemoveExclusionPattern(<args>)

command! -nargs=0 CounterpointNext :call s:CycleCounterpart(1)
command! -nargs=0 CounterpointPrevious :call s:CycleCounterpart(-1)

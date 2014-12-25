" counterpoint.vim - File Counterpart Navigation
" Author:  Josh Petrie <http://joshpetrie.net>
" Version: 1.0

if exists("g:loaded_counterpoint")
  finish
endif

let g:loaded_counterpoint = 1

if !exists("g:counterpoint_depth")
  let g:counterpoint_depth = 0
endif

if !exists("g:counterpoint_search_paths")
  let g:counterpoint_search_paths = []
endif

if !exists("g:counterpoint_exclude_patterns")
  let g:counterpoint_exclude_patterns = []
endif

function! s:RemoveDuplicates(subject)
  let deduplicated = {}
  for item in a:subject
    let deduplicated[item] = ""
  endfor
  return sort(keys(deduplicated))
endfunction

function! s:PrepareSearchPaths(paths, root)
  let results = []
  for path in a:paths
    let result = simplify(a:root . "/" . path)
    let result = fnamemodify(result, ":p")
    let result = substitute(result, "\\\\$", "", "")
    call add(results, result)
  endfor
  return s:RemoveDuplicates(results)
endfunction

function! s:IsCounterpartExcluded(counterpart)
  for exclusion in g:counterpoint_exclude_patterns
    if a:counterpart =~ exclusion
      return 1
    endif
  endfor
  return 0
endfunction

function! s:CycleCounterpart(amount)
  let currentFile = expand("%:t")

  let parts = split(currentFile, "[.]")
  if g:counterpoint_depth <= 0
    let root = parts[0]
  else
    let root = join(parts[0:-g:counterpoint_depth - 1], ".")
  endif

  " Restore the leading dot, if it existed.
  if currentFile[0] == "."
    let root = "." . root
  endif

  " Prepare search paths.
  let paths = copy(g:counterpoint_search_paths)
  call add(paths, ".")
  let paths = s:PrepareSearchPaths(paths, expand("%:h"))

  " Collect the potential counterparts, filter out anything that matches any
  " supplied exclusion patterns, remove any duplicates, and then cycle.
  let results = globpath(join(paths, ","), root . ".*")
  let counterparts = split(results)
  let counterparts = filter(counterparts, "!s:IsCounterpartExcluded(v:val)")
  let counterparts = s:RemoveDuplicates(counterparts)
  if len(counterparts) <= 1
    echo "No counterpart available."
    return
  endif

  let currentPath = expand("%:p")
  let index = 0
  for counterpart in counterparts
    if currentPath == fnamemodify(counterpart, ":p")
      execute ":edit " . fnamemodify(counterparts[(index + a:amount) % len(counterparts)], ":~:.")
      break
    endif

    let index += 1
  endfor
endfunction

command! -nargs=0 CounterpointNext :call s:CycleCounterpart(1)
command! -nargs=0 CounterpointPrevious :call s:CycleCounterpart(-1)

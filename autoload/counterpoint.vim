" counterpoint.vim - cycle between file counterparts
" Maintainer: Josh Petrie <http://joshpetrie.net>
" Version:    1.2

function! <SID>RemoveDuplicates(subject)
  let deduplicated = {}
  for item in a:subject
    let deduplicated[item] = ""
  endfor
  return sort(keys(deduplicated))
endfunction

function! <SID>PrepareSearchPaths(paths, root)
  let results = []
  for path in a:paths
    let result = simplify(a:root . "/" . path)
    let result = fnamemodify(result, ":p")
    let result = substitute(result, "\\\\$", "", "")
    call add(results, result)
  endfor
  return <SID>RemoveDuplicates(results)
endfunction

function! <SID>IsCounterpartExcluded(counterpart)
  for exclusion in g:counterpoint_exclude_patterns
    if a:counterpart =~ exclusion
      return 1
    endif
  endfor
  return 0
endfunction

function! <SID>Jump(counterpart, reuse, command)
    if a:reuse == "!"
      let window = bufwinnr(a:counterpart)
      if window >= 0
        execute window . "wincmd w"
        return
      endif
    endif

    let command = a:command
    if len(command) == 0
      let command = "edit"
    endif

    execute command . " " . a:counterpart
endfunction

function! counterpoint#GetCounterparts()
  let currentFile = expand("%:t")
  if len(currentFile) <= 0
    return ""
  endif

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
  let paths = <SID>PrepareSearchPaths(paths, expand("%:h"))

  " Apply exclusions and remove any duplicates.
  let results = globpath(join(paths, ","), root . ".*")
  let counterparts = split(results)
  let counterparts = filter(counterparts, "!<SID>IsCounterpartExcluded(v:val)")
  let counterparts = <SID>RemoveDuplicates(counterparts)
  return counterparts
endfunction

function! counterpoint#PeekCounterpart(amount)
  let counterparts = counterpoint#GetCounterparts()
  if len(counterparts) <= 1
    return ""
  endif

  let currentPath = expand("%:p")
  let index = 0
  for counterpart in counterparts
    if currentPath == fnamemodify(counterpart, ":p")
      return fnamemodify(counterparts[(index + a:amount) % len(counterparts)], ":~:.")
    endif
    let index += 1
  endfor

  return ""
endfunction

function! counterpoint#CycleCounterpart(amount, reuse, command)
  if g:counterpoint_prompt_threshold > 0 
    let counterparts = counterpoint#GetCounterparts()
    if len(counterparts) - 1 >= g:counterpoint_prompt_threshold
      let options = map(copy(counterparts), "(v:key + 1) . \": \" . fnamemodify(v:val, \":~:.\")")

      let result = inputlist(options)
      if result - 1 < 0
        return
      else
        call <SID>Jump(counterparts[result - 1], a:reuse, a:command)
        return
      endif
    endif
  endif

  let result = counterpoint#PeekCounterpart(a:amount)
  if len(result) == 0
    echo "No counterpart available."
  else
    call <SID>Jump(result, a:reuse, a:command)
  endif
endfunction

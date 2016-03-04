" counterpoint.vim - cycle between file counterparts
" Maintainer: Josh Petrie <http://joshpetrie.net>
" Version:    1.6

function! <SID>RemoveDuplicates (subject)
  let deduplicated = {}
  for item in a:subject
    let deduplicated[item] = ""
  endfor
  return sort(keys(deduplicated))
endfunction

function! <SID>PrepareSearchPaths (paths, root)
  let results = []
  for path in a:paths
    if match(path, "^\\(.:[\\\\/]\\|/\\)") == 0
      let result = path
    else
      let result = simplify(a:root . "/" . path)
      let result = fnamemodify(result, ":p")
    endif

    let result = substitute(result, "\\\\$", "", "")
    call add(results, result)
  endfor
  return <SID>RemoveDuplicates(results)
endfunction

function! <SID>IsCounterpartExcluded (counterpart)
  for exclusion in g:counterpoint_exclude_patterns
    if a:counterpart =~ exclusion
      return 1
    endif
  endfor
  return 0
endfunction

function! <SID>GetRoot (file)
  let parts = split(a:file, "[.]")
  if g:counterpoint_depth <= 0
    let root = parts[0]
  else
    let root = join(parts[0:-g:counterpoint_depth - 1], ".")
  endif

  " Restore the leading dot, if it existed.
  if a:file[0] == "."
    let root = "." . root
  endif

  return root
endfunction

function! <SID>Peek (amount, counterparts)
  let length = len(a:counterparts)
  if length <= 1
    return ""
  endif

  let currentPath = expand("%:p")
  let index = 0
  for counterpart in a:counterparts
    if currentPath == fnamemodify(counterpart, ":p")
      let result = fnamemodify(a:counterparts[(index + a:amount) % length], ":~:.")
      if has("win32") && result[0] == '\'
        " On Windows, fnamemodify with ":." will chop the drive letter from
        " the result if the path is not under the current directory; in this
        " case the path should have been unmodified, so the letter should be
        " restored to the front of the string.
        let result = strpart(counterpart, 0, 2) . result
      endif
      return result
    endif
    let index += 1
  endfor

  return ""
endfunction

function! <SID>Jump (counterpart, reuse, command)
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

function! counterpoint#GetCounterparts ()
  let currentFile = expand("%:t")
  if len(currentFile) <= 0
    return ""
  endif

  " Get the root component.
  let root = <SID>GetRoot(currentFile)

  " Prepare search paths.
  let paths = copy(g:counterpoint_search_paths)
  if g:counterpoint_include_path == 1
    call extend(paths, split(&path, "\\\\\\@<![, ]"))
  endif
  call add(paths, ".")
  let paths = <SID>PrepareSearchPaths(paths, expand("%:h"))

  let counterparts = globpath(join(paths, ","), root . ".*", 0, 1)

  " Include listed buffers that match the root pattern.
  let buffers = []
  if g:counterpoint_include_listed == 1
    for bufferNumber in filter(range(1, bufnr("$")), "bufexists(v:val) && buflisted(v:val)")
      let bufferName = bufname(bufferNumber)
      if len(bufferName) == 0
        continue
      endif

      " Turn buffer name into a full path, unless the buffer is a 'nofile' buffer.
      if match(getbufvar(bufferNumber, "&buftype"), "nofile") == -1
        let bufferName = fnamemodify(bufferName, ":p")
      endif

      " Only allow buffers with a matching root into the list.
      let bufferRoot = fnamemodify(bufferName, ":t")
      let bufferRoot = <SID>GetRoot(bufferRoot)
      if bufferRoot == root
        call add(buffers, bufferName)
      endif
    endfor
  endif

  " Apply exclusions and remove any duplicates.
  let counterparts = filter(counterparts, "!<SID>IsCounterpartExcluded(v:val)")
  call extend(counterparts, buffers)
  let counterparts = <SID>RemoveDuplicates(counterparts)

  return counterparts
endfunction

function! counterpoint#PeekCounterpart (amount)
  return <SID>Peek(a:amount, counterpoint#GetCounterparts())
endfunction

function! counterpoint#CycleCounterpart (amount, reuse, command)
  let counterparts = counterpoint#GetCounterparts()
  if len(counterparts) > 0 && g:counterpoint_prompt_threshold > 0
    let filtered = filter(copy(counterparts), "v:val != expand(\"%:p\")")
    if len(filtered) >= g:counterpoint_prompt_threshold
      let options = map(copy(filtered), "(v:key + 1) . \": \" . fnamemodify(v:val, \":~:.\")")
      let result = inputlist(options)
      if result - 1 < 0
        return
      else
        call <SID>Jump(filtered[result - 1], a:reuse, a:command)
        return
      endif
    endif
  endif

  let result = <SID>Peek(a:amount, counterparts)
  if len(result) == 0
    echo "No counterpart available."
  else
    call <SID>Jump(result, a:reuse, a:command)
  endif
endfunction

" counterpoint.vim - cycle between file counterparts
" Maintainer: Josh Petrie <http://joshpetrie.net>
" Version:    1.1.1

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

command! -bang -nargs=* CounterpointNext :call counterpoint#CycleCounterpart(1, "<bang>", "<args>")
command! -bang -nargs=* CounterpointPrevious :call counterpoint#CycleCounterpart(-1, "<bang>", "<args>")

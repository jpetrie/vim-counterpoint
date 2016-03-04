" counterpoint.vim - cycle between file counterparts
" Maintainer: Josh Petrie <http://joshpetrie.net>
" Version:    1.6

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

if !exists("g:counterpoint_prompt_threshold")
  let g:counterpoint_prompt_threshold = 0
endif

if !exists("g:counterpoint_include_listed")
  let g:counterpoint_include_listed = 0
endif

if !exists("g:counterpoint_include_path")
  let g:counterpoint_include_path = 0
endif

command! -bang -nargs=* CounterpointNext :call counterpoint#CycleCounterpart(1, "<bang>", "<args>")
command! -bang -nargs=* CounterpointPrevious :call counterpoint#CycleCounterpart(-1, "<bang>", "<args>")

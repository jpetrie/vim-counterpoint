# counterpoint.vim

Use Counterpoint to easily switch between file counterparts (`.h` and `.cpp`, et
cetera) using `:CounterpointNext` and `:CounterpointPrevious`.

Counterpoint works by taking the current file, determining the root file
name, and switching between files with the same root but different extensions.
The root of the file is the portion of the file name before the *first* `.`;
this allows Counterpoint to operate as you would expect when used in a
context containing "multi-level" file extensions, such as a source tree
containing `Window.h` and `Window.cpp` *as well as* `Window.mac.mm` and
`Window.win.cpp` (`Window` is the root and all four variations are valid
counterparts).

By default, if the current file *starts* with a `.`, Counterpoint uses the
everything before the *second* dot in the filename as the root. This allows
Counterpoint to support switching between alternate versions of invisible
files.

Counterpoint switches between counterparts in alphabetical order.  

## Installation

Install via [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/jpetrie/vim-counterpoint.git

Use Pathogen's `:Helptags` command to generate help, and then use `:help counterpoint`
to view the manual. Counterpoint does not provide mappings for its commands by default.
It is recommended that you map Counterpoint's commands in your `.vimrc`, for example:

    :nnoremap <leader>a :CounterpointNext<CR>
    :nnoremap <leader>A :CounterpointPrevious<CR>

## Customization

Counterpoint's manual (`:help counterpoint`) describes the available configuration
options in more detail; this section provides a brief overview of the most common
options.

### Search Paths

Counterpont can search multiple directories for counterpart files (this can be useful
in cases where source and header files are kept in seperate, sibling directories).

To add additional search paths, set `g:counterpoint_search_paths` to an array containing
the desired paths:

    let g:counterpoint_search_paths = ["relative/path/here", "another/path/here"]

Only relative paths should be used; Counterpoint will always view them as being relative
to the directory containing the current file. Counterpoint will always search the 
current file's directory for counterparts as well; you don't need to explicitly specify
it in the search path array.

### Excluding Files

Counterpoint can be configured to exclude files, based on regular expressions, from the
counterpart set. By default, the exclusion pattern list is empty, but can be manipulated
by changing the value of the `g:counterpoint_exclude_patterns` array:

    let g:counterpoint_exclude_patterns = ["patternA", "patternB"]

When cycling between counterparts, any file that matches any of the regular expressions
in the exclusion set will be removed from the set of available counterparts.

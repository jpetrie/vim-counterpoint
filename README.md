# counterpoint.vim

Use Counterpoint to easily switch between file counterparts
(`.h` and `.cpp`, et cetera) using `:CounterpointNext` and 
`:CounterpointPrevious`.

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
Counterpoint to support switching between (for example) `.vimrc` and
`.vimrc.old`.

Counterpoint switches between counterparts in alphabetical order.  

## Installation

Install via [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/jpetrie/vim-counterpoint.git

Use Pathogen's `:Helptags` command to generate help, and then use `:help counterpoint`
to view the manual.

## Customization

### Mappings

It is recommended that you map Counterpoint's commands in your `.vimrc`, for example:

    :nnoremap <leader>a :CounterpointNext<CR>
    :nnoremap <leader>A :CounterpointPrevious<CR>

### Search Paths

Counterpoint can search multiple directories for counterpart files (for cases where
source and header files are kept in seperate sibling directories, for example). Once
 Counterpoint has determined the root file name, it searches all of its internal search
paths for files with the same root and differing extensions; the resulting set of paths
becomes the counterpart set that Counterpoint cycles through.

By default, Counterpoint's search paths consist only of the current directory ("`.`").
To add additional search paths, use:

    :CounterpointAddSearchPath "relative/path/here"

You can remove search paths with:

    :CounterpointRemoveSearchPath "relative/path/here"

Only relative paths should be used; in order to provide consistent behavior regardless
of one's `autochdir` setting, Counterpoint will interpret search paths as being relative
to the directory containing the current file when scanning for counterparts.

This means you usually want to add search paths in pairs. If you have a source tree where
`.cpp` files are kept in `src/` and headers in `inc/`, you may want to use the following:

    :CounterpointAddSearchPath "../src"
    :CounterpointAddSearchPath "../inc"

(If you were to add only one of these paths, say just `../src`, then you could cycle from
the header to source file, but you would not be able to cycle back.)

### Excluding Files

Counterpoint can be configured to exclude files, based on regular expressions, from the
counterpart set. By default, the exclusion pattern list is empty, but can be manipulated
via the following functions:

    :CounterpointAddExclusionPattern "pattern"
    :CounterpointRemoveExclusionPattern "pattern"

When cycling between counterparts, any file that matches any of the regular expressions
in the exclusion set will be removed from the set of available counterparts.

The patterns in the exclusion set are evaluated against potential counterpart paths using
vim's "=~" operator, so the caveats of that operator apply (`'magic'` acts as set and
`'cpoptions'` acts empty; see `:help expr-=~` for details).


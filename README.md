**This project is looking for a new maintainer. See [Issue #19](https://github.com/jpetrie/vim-counterpoint/issues/19) for more details.**

# counterpoint.vim

Use Counterpoint to easily switch between file counterparts (`.h` and `.cpp`, et cetera) using `:CounterpointNext` and
`:CounterpointPrevious`.

Counterpoint works by taking the current file, determining the root file name, and switching between files with the same
root but different extensions.  The root of the file is the portion of the file name before the *first* `.`; this allows
Counterpoint to operate as you would expect when used in a context containing "multi-level" file extensions, such as a
source tree containing `Window.h` and `Window.cpp` *as well as* `Window.mac.mm` and `Window.win.cpp` (`Window` is the
root and all four variations are valid counterparts).

By default, if the current file *starts* with a `.`, Counterpoint uses the everything before the *second* dot in the
filename as the root. This allows Counterpoint to support switching between alternate versions of invisible files.

Counterpoint switches between counterparts in alphabetical order. If you invoke the Counterpoint commands with the
postfix bang modifier (`:CounterpointNext!`), Counterpoint will try to switch to an existing window containing the
counterpart file before it tries to open it. It's also possible to specify arguments to the commands to control how the
file is opened (for example, to open it in a new split). See `:help counterpoint` for details.

## Installation

Counterpoint has no special installation requirements and can be installed via your preferred plugin management method.

Counterpoint does not provide mappings for its commands by default.  It is recommended that you map Counterpoint's
commands in your `.vimrc`, for example:

    :nnoremap <leader>a :CounterpointNext<CR> :nnoremap <leader>A :CounterpointPrevious<CR>

Appending a `!` to a command causes it to try to switch to an existing window showing the counterpart buffer if
possible. Supplying arguments to a command allows you to define how the counterpart is opened, if needed. For example:

    :nnoremap <leader>a :CounterpointNext! aboveleft vsplit

This mapping will open the next counterpart in a split window on the left, unless that counterpart is already visible in
another window (in which case that window will get the focus).

## Customization

Counterpoint's manual (`:help counterpoint`) describes the available configuration options in more detail; this section
provides a brief overview of the most common options.

### Search Paths

Counterpoint can search multiple directories for counterpart files (this can be useful in cases where source and header
files are kept in separate, sibling directories). If you've already configured your `path` setting in vim (for `gf` and
the like), you can instruct Counterpoint to read `path` by setting `g:counterpoint_include_path` to 1. 

To add additional search paths, set `g:counterpoint_search_paths` to an array containing the desired paths:

    let g:counterpoint_search_paths = ["relative/path/here", "another/path/here"]

Absolute or relative paths are permitted. Counterpoint will treat relative paths as being relative to the directory
containing the current file. The current file's directory will always be searched for counterparts as well; you don't
need to explicitly specify it in the search path array.

### Excluding Files

Counterpoint can be configured to exclude files, based on regular expressions, from the counterpart set. By default, the
exclusion pattern list is empty, but can be manipulated by changing the value of the `g:counterpoint_exclude_patterns`
array:

    let g:counterpoint_exclude_patterns = ["patternA", "patternB"]

When cycling between counterparts, any file that matches any of the regular expressions in the exclusion set will be
removed from the set of available counterparts.

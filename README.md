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

Counterpoint switches between counterparts in alphabetical order. If you invoke
the Counterpoint commands with the postfix bang modifier (`:CounterpointNext!`),
Counterpoint will try to switch to an existing window containing the counterpart
file before it tries to open it. It's also possible to specify arguments to the 
commands to control how the file is opened (for example, to open it in a new
split). See `:help counterpoint` for details.

## Installation

Install via [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/jpetrie/vim-counterpoint.git

Use Pathogen's `:Helptags` command to generate help, and then use `:help counterpoint`
to view the manual. Counterpoint does not provide mappings for its commands by default.
It is recommended that you map Counterpoint's commands in your `.vimrc`, for example:

    :nnoremap <leader>a :CounterpointNext<CR>
    :nnoremap <leader>A :CounterpointPrevious<CR>

Appending a `!` to a command causes it to try to switch to an existing window showing
the counterpart buffer if possible. Supplying arguments to a command allows you to 
define how the counterpart is opened, if needed. For example:

    :nnoremap <leader>a :CounterpartNext! aboveleft vsplit

This mapping will open the next counterpart in a split window on the left, unless that
counterpart is already visible in another window (in which case that window will get
the focus).

## Customization

Counterpoint's manual (`:help counterpoint`) describes the available configuration
options in more detail; this section provides a brief overview of the most common
options.

### Search Paths

Counterpoint can search multiple directories for counterpart files (this can be useful
in cases where source and header files are kept in separate, sibling directories).

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

## Changes

### Version 1.2 (Current)

 - Adding the ability to configure Counterpoint to prompt you for direct counterpart
   jumps if the number of available counterparts meets a certain threshold. Disabled
   by default, see `:help g:counterpoint_prompt_threshold` for details.

### Version 1.1.1

 - Fixed a bug that caused errors when trying to switch counterparts in an unnamed
   buffer (such as the default).

### Version 1.1

 - Cycling commands can use the postfix bang (`CounterpointNext!`) to indicate that they
   should try to switch to an existing window on the target buffer, if possible.
 - Cycling commands can take arguments. If present, these arguments will define the
   command that will be run to edit the target file.
 - Broke cycling and computation of the next counterpart into separate functions.

### Version 1.0.1

 - Counterpoint's code is now delay-loaded via vim's autoload mechanism.

### Version 1.0

 - Initial stable version.


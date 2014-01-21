# counterpoint.vim

Use Counterpoint to easily switch between file counterparts
(`.h` and `.cpp`, et cetera) using `:CounterpointNext` and 
`:CounterpointPrevious`.

Counterpoint works by taking the current file, determining the root file
name, and switching between files with the same root but different extensions.
The root of the file is the portion of the file name before the *first* `.`;
this allows Counterpoint to operate as you would expect when used in a
context contained "multi-level" file extensions, such as a source tree
containing `Window.h` and `Window.cpp` *as well as* `Window.mac.mm` and
'Window.win.cpp` (`Window` is the root and all four variations are valid
counterparts).

By default, if the current file *starts* with a `.`, Counterpoint uses the
everything before the *second* dot in the filename as the base. This allows
Counterpoint to support switching between (for example) `.vimrc` and
`.vimrc.old`.

Counterpoint switches between counterparts in alphabetical order.  

## Installation

Install via [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/jpetrie/vim-counterpoint.git

Use Pathogen's `:Helptags` command to generate help, and then use `:help counterpoint` to view the manual.

## Customization

It is recommended that you map Counterpoint's commands in your `.vimrc`, for example:

    :nnoremap <leader>a :CounterpointNext<CR>
    :nnoremap <leader>A :CounterpointPrevious<CR>


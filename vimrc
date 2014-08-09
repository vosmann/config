
set number
" set textwidth=120  " Longer lines will be broken.

set shiftwidth=4  " Operation '>>' indents 4 spaces, '<<'unindents 4 spaces.
set tabstop=4     " A hard tab displays as four spaces.
set expandtab     " Insert spaces when writing tabs.
set softtabstop=4 " Insert/remove four spaces when hitting a tab or backspace.
set shiftround    " Round indent to multiple of 'shiftwidth'.
set autoindent    " Align the indent of a new line with the indent of the previous line.


" https://github.com/tpope/vim-pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" https://github.com/nvie/vim-flake8
" pip install flake8

" https://github.com/scrooloose/nerdtree.git
autocmd vimenter * NERDTree
" Opens nerd tree even if no files were specified.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

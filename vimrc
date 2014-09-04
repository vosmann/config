
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
autocmd VimEnter * wincmd p " Focus on editor after opening file (instead of the tree).

" Close vi if nerd tree is the last buffer left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Opens nerd tree even if no files were specified.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" For commenting and uncommenting things.
" git clone https://github.com/scrooloose/nerdcommenter.git
filetype plugin on


" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction


" Command ':Bd' executes ':bd' to delete buffer in current window.
" I renamed the original command ':Bclose' to ':Bd'. Hopefully no colissions.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bd!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bd(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bd!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bd call s:Bd('<bang>', '<args>')
nnoremap <silent> <Leader>bd :Bd<CR>

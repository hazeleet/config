"
" polyglot
"
let g:polyglot_disabled = ['sensible']

"
" Vundle
" 
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'thaerkh/vim-workspace'
Plugin 'valloric/youcompleteme'
Plugin 'scrooloose/syntastic'
Plugin 'tinted-theming/base16-vim'
Plugin 'sheerun/vim-polyglot'
call vundle#end()            " required
filetype plugin indent on    " required


"
" base16
"
if filereadable(expand("$HOME/.config/tinted-theming/set_theme.vim"))
  let base16colorspace=256
  source $HOME/.config/tinted-theming/set_theme.vim
endif

"
" YCM
"
"let g:ycm_enable_inlay_hints = 1
let g:ycm_confirm_extra_conf = 0
function! s:CustomizeYcmQuickFixWindow()
  wincmd K
  8wincmd _
  wincmd p
endfunction
autocmd User YcmQuickFixOpened call s:CustomizeYcmQuickFixWindow()


"
" nerdtree
"
let g:NERDTreeMapOpenExpl=''
let g:NERDTreeMapOpenSplit=''
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeRespectWildIgnore=1
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeMenuUp='s'
let g:NERDTreeMenuDown='r'
let g:NERDTreeMapRefresh='a'
let g:NERDTreeMapCustomOpen='t'
let g:NERDTreeMapOpenVSplit='k' "for key dup issue
"let g:NERDTreeSortOrder=['\/$', '*', '[[-timestamp]]']
autocmd StdinReadPre * let s:std_in=1
" Start NERDTree when Vim is started without file arguments.
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


"
" vim-airline
"
let g:airline#extensions#tabline#enabled = 1


"
" workspace
"
let g:workspace_autosave_always = 1
let g:workspace_autosave_untrailspaces = 0
"let g:workspace_autosave_ignore = ['gitcommit']

"
" syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_asm_checkers = ['nasm']


"
" folding
" 
set foldmethod=syntax
autocmd FileType python setlocal foldmethod=indent
autocmd FileType scss setlocal foldmethod=indent
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif


"
" quickfix
"
function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    if a:pfx == 'l'
      wincmd J
    else
      wincmd K
    endif
    8wincmd _
    wincmd p
  endif
endfunction

"
" default
"
syntax on
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab smartindent cindent
autocmd FileType markdown setlocal spell spelllang=en,cjk
autocmd FileType c setlocal noexpandtab cc=80
autocmd FileType h setlocal noexpandtab cc=80
autocmd FileType make setlocal noexpandtab cc=80
autocmd BufRead,BufNewFIle *.S setlocal filetype=asm
autocmd BufRead,BufNewFIle *.s setlocal filetype=asm
set wildmode=list:longest,full
set backspace=indent,eol,start
set hlsearch
set encoding=utf-8
set wildignore=.git,.next,node_modules,__pycache__,.build,.cache,compile_commands.json
set iskeyword-=_

"
" Mapping
"
let mapleader=','

map <leader>: @:<CR>

" Replace hjkl
noremap a h
noremap A J
noremap r j
noremap R L
noremap s k
noremap S H
noremap t l
noremap T K
noremap h a
noremap H A
noremap j t
noremap J T
noremap k r
noremap K R
noremap l s
noremap L S

" Extension Window Toggle
map <leader>a :NERDTreeToggle<CR>
imap <leader>a <C-[>:NERDTreeToggle<CR>
map <leader>r :call ToggleList("Location List", 'l')<CR>
imap <leader>r <C-o>:call ToggleList("Location List", 'l')<CR>
map <leader>s :call ToggleList("Quickfix List", 'c')<CR>
imap <leader>s <C-o>:call ToggleList("Quickfix List", 'c')<CR>

" write,close,quit
cabbrev <silent> bd <C-r>=(getcmdtype()==#':' && getcmdpos()==1 ? 'lclose\|bdelete' : 'bd')<CR>
map <leader>c :bd<CR>
imap <leader>c <C-[>:bd<CR>
map <leader>C <C-w>c
imap <leader>C <C-w>c
map <leader>q :wqall<CR>
imap <leader>q <C-[>:wqall<CR>
map <leader>w :w<CR>
imap <leader>w <C-o>:w<CR>

" cursor
"imap <leader>o <C-o>o
"imap <leader>O <C-o>O
map <leader>h :bprevious<CR>
imap <leader>h <C-o>:bprevious<CR>
map <leader>. :bnext<CR>
imap <leader>. <C-o>:bnext<CR>
map <leader><Left> <C-w>h
imap <leader><Left> <C-w>h
map <leader><Right> <C-w>l
imap <leader><Right> <C-w>l
map <leader><Up> <C-w>k
imap <leader><Up> <C-w>k
map <leader><Down> <C-w>j
imap <leader><Down> <C-w>j
map <PageUp> <C-u>
map <PageDown> <C-d>

" Split window
map <leader>o :split<CR>
imap <leader>o <C-o>:split<CR>
map <leader>O :vsplit<CR>
imap <leader>O <C-o>:vsplit<CR>

" Sizing window
map <leader>+ <C-w>5+
imap <leader>+ <C-w>5+
map <leader>- <C-w>5-
imap <leader>- <C-w>5-
map <leader>< <C-w>5<
imap <leader>< <C-w>5<
map <leader>> <C-w>5>
imap <leader>> <C-w>5>
map <leader>= <C-w>=
imap <leader>= <C-w>=
map <leader>_ <c-w>_
imap <leader>_ <c-w>_
map <leader>\| <c-w>\|
imap <leader>\| <c-w>\|

" Ycm 
map <leader>t :cn<CR>
imap <leader>t <C-o>:cn<CR>
map <leader>T :cp<CR>
imap <leader>T <C-o>:cp<CR>
map <leader>g :YcmCompleter GoTo<CR>
imap <leader>g <C-o>:YcmCompleter GoTo<CR>
map <leader>G <C-o>
imap <leader>G <C-o><C-o>
map <leader>b :YcmCompleter GoToReferences<CR>
imap <leader>b <C-o>:YcmCompleter GoToReferences<CR>
map <leader>B <Plug>(YCMFindSymbolInWorkspace)
imap <leader>B <C-o><Plug>(YCMFindSymbolInWorkspace)
imap <leader>p <Plug>(YCMToggleSignatureHelp)

map <leader>= V%=

map <leader>/ :noh<CR>
imap <leader>/ <C-o>:noh<CR>
map <leader>' :!%:p<CR>
imap <leader>' <C-o>:!%:p<CR>


" folding
map <leader>f za
imap <leader>f <C-o>za
map <leader>F zR
imap <leader>F <C-o>zR

highlight Comment cterm=italic
highlight htmlItalic cterm=italic
highlight htmlBold cterm=Bold

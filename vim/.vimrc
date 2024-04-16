" ~/.vimrc: simple Vim9 configuration file,
" no plugin, just settings and keymaps
" ---
" Vim editor - https://www.vim.org




" Undodir & Linebreak {{{
if has('persistent_undo')
    if !isdirectory(expand('~/.vim/undodir'))
        execute "!mkdir -p ~/.vim/undodir &>/dev/null"
    endif
    set undodir=$HOME/.vim/undodir
    set undofile
endif
" ---
if has('linebreak')
    let &showbreak='  ~'
endif
" }}}




" Leaders & Caret {{{
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" }}}




" Syntax & Filetype {{{
syntax on
filetype plugin indent on
colorscheme lunaperche
set background=dark
" }}}




" Options {{{
set exrc
set title
set shell=bash
set runtimepath+=~/.vim_runtime
set clipboard=unnamedplus
set number relativenumber mouse=a
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set ruler scrolloff=8 sidescrolloff=16
set autoindent
set formatoptions+=l
set hlsearch incsearch
set nowrap nospell
set ignorecase smartcase smartindent
set noswapfile nobackup
set showmode showcmd
set cursorline noerrorbells novisualbell
set cursorlineopt=number,line
set splitbelow splitright
set equalalways
set nofoldenable foldmethod=marker
set matchpairs+=<:>
set autochdir
set hidden
set updatetime=100
set timeoutlen=2000
set ttimeoutlen=0
set termencoding=utf-8 encoding=utf-8 | scriptencoding utf-8
set sessionoptions=blank,buffers,curdir,folds,tabpages,help,options,winsize
set colorcolumn=
set cmdheight=1
set nrformats-=alpha
set fillchars=vert:┃,fold:━
set laststatus=2 showtabline=1
set nocompatible
set esckeys
" ---
set path+=**
set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,preview,noinsert,noselect
set complete=.,w,b,u,t,i,kspell
set complete+=k/usr/share/dict/american-english
set dictionary+=/usr/share/dict/american-english
set wildmenu wildoptions=fuzzy,pum,tagfile
set wildchar=<Tab> wildmode=full
set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/tmp/*,*.so,*.swp,*.zip
set shortmess+=c
set belloff+=ctrlg
" ---
if has('gui_running')
    set guioptions=i
    set guicursor+=a:blinkon0
    set columns=130 lines=50
    set vb t_vb=
    if system('fc-list') =~ 'Fira Code'
        set guifont=Fira\ Code\ 10
    endif
endif
" }}}




" Functions {{{
function! s:ToggleQF()
    let g:loclist = 'lclose'
    let g:quickfix = !exists("g:quickfix") || g:quickfix ==# 'cclose' ? 'copen' : 'cclose'
    silent! execute g:loclist
    silent! execute g:quickfix
endfunction
" ---
function! s:MarkLineQF()
    let l:qf_list = getqflist()
    let l:qf_entry = {
              \ 'bufnr': bufnr("%"),
              \ 'lnum': line("."),
              \ 'col': col("."),
              \ 'text': getline("."),
              \ 'filename': expand("%:p"),
          \ }
    call add(l:qf_list, l:qf_entry)
    call setqflist(l:qf_list)
    echo 'current line to quickfix'
endfunction
" ---
function! s:ResetQF()
    call setqflist([])
    echo 'reset quickfix'
endfunction
" ---
function! s:ScratchBuffer()
    let target_buffer = bufnr('/tmp/scratchbuffer')
    let target_window = bufwinnr(target_buffer)
    if target_buffer != -1 && target_window != -1
        execute target_window . 'wincmd w'
    else
        execute 'edit /tmp/scratchbuffer'
        setlocal bufhidden=wipe
        setlocal nobuflisted
        setlocal noswapfile
        setlocal filetype=text
    endif
endfunction
" }}}




" Augroups {{{
augroup netrw_prettyfier
    autocmd!
    autocmd FileType netrw
          \ setlocal bufhidden=wipe|
          \ setlocal nobuflisted
    autocmd VimEnter *
          \ if !argc() && exists(':Explore')|
          \     Explore|
          \ endif
    let g:netrw_banner = 0
    let g:netrw_liststyle = 4
    let g:netrw_sort_options = 'i'
    let g:netrw_sort_sequence = '[\/]$,*'
    let g:netrw_browsex_viewer = 'xdg-open'
    let g:netrw_list_hide = '^\./$'
    let g:netrw_hide = 1
    let g:netrw_preview = 0
    let g:netrw_alto = 1
    let g:netrw_altv = 0
augroup end
" ---
augroup linenumber_prettyfier
    autocmd!
    autocmd WinEnter,BufEnter,FocusGained,InsertLeave *
          \ if &number == 1|
          \     set relativenumber|
          \ endif|
          \ set cursorline
    autocmd WinLeave,BufLeave,FocusLost,InsertEnter *
          \ if &number == 1|
          \     set norelativenumber|
          \ endif|
          \ set nocursorline
augroup end
" ---
augroup cursorcolumn_prettyfier
    autocmd!
    autocmd InsertEnter *
          \ if &filetype != 'text' && &filetype != 'markdown' && &filetype != 'tex'|
          \     let &colorcolumn = '121,'.join(range(121,999),',')|
          \ endif
    autocmd InsertLeave *
          \ if &filetype != 'text' && &filetype != 'markdown' && &filetype != 'tex'|
          \     set colorcolumn=|
          \ endif
augroup end
" ---
augroup writer_filetype
    autocmd!
    autocmd FileType markdown,tex,text
          \ setlocal nonu nornu|
          \ setlocal wrap conceallevel=2|
          \ noremap <buffer> j gj|
          \ noremap <buffer> k gk
augroup end
" ---
augroup scratchbuffer_autosave
    autocmd!
    autocmd TextChanged,TextChangedI /tmp/scratchbuffer silent write
augroup end
" }}}




" Commands {{{
command! ClearSearch
      \ silent! execute 'let @/=""'|
      \ echo 'cleared last search'
command! ClearSpaces
      \ silent! execute 'let v:statusmsg = "" | verbose %s/\s\+$//e'|
      \ echo !empty(v:statusmsg) ? v:statusmsg : 'cleared trailing spaces'
command! LineWrap
      \ silent! execute &wrap ? 'setlocal nowrap' : 'setlocal wrap'|
      \ silent! execute &wrap ?'noremap <buffer> j gj|noremap <buffer> k gk' : 'unmap <buffer> j|unmap <buffer> k'|
      \ echo &wrap ? 'lines wrapped' : 'lines unwrapped'
" ---
if has('gui_running')
    command! GuiFont silent! execute 'set guifont=*'
endif
" }}}




" Keymaps {{{
noremap <silent><C-h> (
noremap <silent><C-l> )
noremap <silent><C-j> }
noremap <silent><C-k> {
" ---
nnoremap <silent>Y y$
vnoremap <silent>H <gv
vnoremap <silent>L >gv
xnoremap <silent>J :move '>+1<CR>gv=gv
xnoremap <silent>K :move '<-2<CR>gv=gv
" ---
nnoremap <leader>j :buffers!<CR>:buffer<Space>
nnoremap <leader>k :buffer#<CR>
nnoremap <leader>o :tabnew %<CR>
nnoremap <leader>c :tabclose<CR>
" ---
nnoremap <leader>a :call <SID>ToggleQF()<CR>
nnoremap <leader>m :call <SID>MarkLineQF()<CR>
nnoremap <leader>r :call <SID>ResetQF()<CR>
nnoremap <leader>w :call <SID>ScratchBuffer()<CR>
" ---
nnoremap <leader>e :Explore<CR>
tnoremap <silent><C-x> <C-\><C-n>
" }}}

" vim: fdm=marker:sw=2:sts=2:et

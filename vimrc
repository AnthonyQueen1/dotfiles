call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'w0rp/ale'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'skreek/skeletor.vim'
Plug 'yggdroot/indentline'
Plug 'townk/vim-autoclose'
Plug 'mbbill/undotree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'pangloss/vim-javascript'

call plug#end()

autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd vimenter * NERDTree "nerd tree auto open
let NERDTreeShowHidden=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

set cursorline
set nocompatible
set showcmd
set autoread
set ignorecase
set smartcase
set ruler
syntax on
set wrapmargin=8
set number
filetype plugin on
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=4
set smarttab
set fillchars+=vert:\  

"powerline font settings
set guifont=Inconsolata\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'

"ale settings
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {'js': ['eslint']}
let g:ale_fixers = {'js': ['eslint']}

colo skeletor

"// in visual searches for highlighted text
vnoremap // y/<C-R>"<CR>

"remap move bt splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <space> <leader>

"fzf bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" same as above, but for Files command
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

"fzf commands
nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>

"nerd tree
map <F2> :NERDTreeToggle<CR>

com! Vimrc tabnew ~/.vimrc
com! Notes tabnew ~/docs/notes
com! Pjl call PrettifyJSONLine(line("."))

com! Pja call Pj ()

fu! PrettifyJSON (lines)
    for line in a:lines
        line !python -m json.tool
    endfor
endf

fu! PrettifyJSONLine (lnum)
    exe "" . a:lnum . "!python -m json.tool"
endf

fu! Pj ()
    echo "prettifying all lines"
    let lnum = line("$")
    while lnum >= 1
        call PrettifyJSONLine(lnum)
        let lnum = lnum-1
    endwhile
    %s/\\n/\r/g
    set ft=javascript
endf

set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set noshowmode              " Don't show the mode since we're using lightline
set cc=80                   " set colour columns for good coding style
set expandtab               " convert tabs to white space
set tabstop=4               " number of columns occupied by a tab character
set shiftwidth=4            " width for autoindents
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set showtabline=2           " show the lightline bufferline tabline

filetype plugin indent on   " allows auto-indenting depending on file type

" Install plug if it's not installed
if empty(glob("$HOME/.local/share/nvim/site/autoload/plug.vim"))
  silent !curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim"
    \ --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" specify directory for plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'w0ng/vim-hybrid' "colorscheme
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator' "tmux navigation
Plug 'mengelbrecht/lightline-bufferline' " buffer display
Plug 'prabirshrestha/vim-lsp'
Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'

call plug#end()

" colorscheme
set background=dark
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 " Remove if using the default palette.
colorscheme hybrid

" Wrapping
autocmd BufRead,BufNewFile *.py setlocal textwidth=79
autocmd BufRead,BufNewFile *.md setlocal textwidth=79

let mapleader="\;"

" fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fa :Ag<CR>
let g:fzf_layout = { 'up': '~40%' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-i': 'vsplit' }

" lightline/bufferline
let g:lightline = {
      \ 'colorscheme': 'simpleblack',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }

let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" tmux-style navigation
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-h> <C-w>h
nnoremap <c-l> <C-w>l

noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
noremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>
let g:tmux_navigator_save_on_switch = 1 " Save on switch


" tab/shift+tab to switch buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" commentary plugin uses /* style */ comments for C family, use '//' instead
autocmd FileType c setlocal commentstring=//\ %s 
autocmd FileType cpp setlocal commentstring=//\ %s 

""
"" LSP settings
"""""""""""""""

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)

    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.cpp, *.c, *.h, *.py, *.rs call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

if executable('clangd-12')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd-12', '-background-index', '-header-insertion=never']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif


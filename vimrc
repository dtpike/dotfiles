" Install termdebug
packadd termdebug

" Install vim-plug if it isn't installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Plug 'Valloric/YouCompleteMe' " For Ultisnips
" Plug 'rdnetto/YCM-Generator'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'derekwyatt/vim-fswitch'
Plug 'tomtom/tcomment_vim' " Plugin to assist with commenting out blocks of text:
Plug 'SirVer/ultisnips' " Track the ultisnips engine.
Plug 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them
Plug 'octol/vim-cpp-enhanced-highlight' " Better C++ Syntax Highlighting:
Plug 'lyuts/vim-rtags' " A plugin to use rtags in vim. (rtags allows for code following, some refactoring, etc.)
Plug 'mrtazz/DoxygenToolkit.vim' " Plugin to generate doxygen documentation strings:
Plug 'majutsushi/tagbar' " tagbar - allows browsing tags of the current source file
Plug 'junegunn/vim-easy-align' " Plugin to allow easy alignment around various symbols
Plug 'easymotion/vim-easymotion' "Plugin to make it easier to use motions to jump to words and characters
Plug 'mhinz/vim-startify' "Plugin to provide a useful start screen in vim
Plug 'mhinz/vim-sayonara' "Plugin to make it easy to delete a buffer and close the file
" Plug 'chriskempson/base16-vim', { 'do': function('FixupBase16') } "Base16 color schemes
Plug 'chriskempson/base16-vim' "Base16 color schemes
Plug 'christoomey/vim-tmux-navigator' "vim/tmux navigator
Plug 'tpope/vim-sleuth'
Plug 'vim-scripts/SearchComplete' " Tab-completion for '/' searching
Plug 'tmhedberg/matchit' " matchit plugin
Plug 'mhinz/vim-grepper'
Plug 'justinmk/vim-sneak' " Faster than using 'f'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy search
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'heavenshell/vim-jsdoc'
Plug 'prabirshrestha/vim-lsp'
call plug#end()

set nocompatible
filetype off

set expandtab
set splitbelow
set splitright
set number
set ignorecase
set smartcase
set nomousehide 
set wildmenu

autocmd Filetype python setlocal ts=4 sw=4 tw=79 "python settings
autocmd Filetype cpp setlocal ts=2 sw=2 tw=80 "quanergy cpp convention
autocmd Filetype xml setlocal ts=4 sw=4 tw=0
autocmd Filetype json setlocal ts=2 sw=2 tw=0 "JSON convention
autocmd Filetype cmake setlocal ts=2 sw=2 tw=0 tw=79 "cmake convention
autocmd Filetype md setlocal tw=80

au BufNewFile,BufRead Jenkinsfile setf groovy " Treat Jenkinsfile's with groovy syntax

let python_highlight_all=1 " Vim built-in syntax highlighting for python

let $XMLLINT_INDENT='    ' " Set xmllint to 4 space indentation

filetype plugin indent on    " required
" Never automatically continue comment on next line
" au FileType * set fo-=c fo-=r fo-=o

syntax enable
set background=dark

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" F6 -> reload all buffers and keep color scheme intact
" noremap <F6> :execute 'bufdo :e' | source $VIMRUNTIME/syntax/syntax.vim

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

" TODO replace with Plug 'piec/vim-lsp-clangd' 
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> gp <plug>(lsp-peek-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.py,*.cpp,*.c,*.h call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" configure ALE linters
let g:ale_linters = {
\   'python': ['flake8'],
\   'cpp': ['clangtidy'],
\}

" vim-airline: ensure the status line is always displayed
set laststatus=2
let g:airline#extensions#tabline#enabled = 1 " enable the list of buffers
let g:airline#extensions#ale#enabled = 1 " enable ale messages in statusline
let g:airline#extensions#tabline#fnamemod = ':t' " show just the filename
let g:airline_powerline_fonts = 1
let g:ycm_confirm_extra_conf = 0 " Turn off prompting to load .ycm_extra_conf.py
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YouCompleteMe use tag files for completion as well:

" NERD Tree shortcut
map <F5> :NERDTreeToggle<CR>
let NERDTreeChDirMode = 2
nnoremap <leader>n :NERDTree .<CR>

" Ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"
let g:UltiSnipsEditSplit="vertical" " If you want :UltiSnipsEdit to split your window.
set rtp+=~/dotfiles " add to runtime paths for Ultisnips

" Mapping for fswitch, to switch between header
" and source:
nnoremap <leader>s :FSHere<CR>

" Key mappings for clang-format, to format source code:
map <leader>f :py3f /usr/share/vim/addons/syntax/clang-format-6.0.py<CR>

" custom vim split commands

" Tmux style pane navigation in vim
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-h> <C-w>h
nnoremap <c-l> <C-w>l

" tmux navigation through vim splits
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
" Use tab and shift+Tab to switch buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
let g:tmux_navigator_save_on_switch = 1 " This will execute the update command on leaving vim to a tmux pane. Default is Zero

" YCM
nnoremap <leader>ci :YcmCompleter GoToImprecise<CR>
nnoremap <leader>cj :YcmCompleter GoTo<CR>
nnoremap <leader>ct :YcmCompleter GetType<CR>
nnoremap <leader>cd :YcmCompleter GetDoc<CR>
nnoremap <leader>cr :YcmCompleter GoToReferences<CR>
nnoremap <leader>cf :YcmCompleter FixIt<CR>
" set completopt-=preview "Disable preview window on completions

" fzf mappings
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>ff :Files<CR>
noremap <leader>fh :BCommits<CR>
noremap <leader>fc :BLines<CR>
noremap <leader>fb :Buffers<CR>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-i': 'vsplit' }

" Check this link if having issues with displaying 'down'
" https://github.com/junegunn/fzf/issues/1486
let g:fzf_layout = { 'up': '~40%' }

" tagbar config. Enable it using this key map:
nmap <F8> :TagbarToggle<CR>
" Have it autofocus on open:
let g:tagbar_autofocus = 1

" Tell vim to look for a tags file in the current
" directory, and all the way up until it finds one:
set tags=./tags;/

nnoremap <leader>q :Sayonara!<CR> " Mapping to close the file in the current buffer:

" Vim sneak
let g:sneak#label = 1 " minimaist vim-sneak

" replace s with f for sneaking
nmap f <Plug>Sneak_s 
nmap F <Plug>Sneak_S

" Set up fswitch to work with the directory structures
" I'm currently using:
augroup fswitch_cpp
   au!
   au BufEnter *.h let b:fswitchdst  = 'cpp,hpp,cc,c'
   au BufEnter *.h let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,reg:|include/\w\+|src|,impl'
   au BufEnter *.cpp let b:fswitchdst  = 'hpp,h'
   au BufEnter *.cpp let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,../include,reg:|src/\(\w\+\)/src|src/\1/include/**|'
   au BufEnter *.hpp let b:fswitchdst  = 'h,cpp'
   au BufEnter *.hpp let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,../src,..'
augroup END

" Function, courtesy of Marc Gallant, to make it easy
" to switch between C and C++ header and source files
" using fzf.
function! FZFSameName(sink, pre_command, post_command)
    let current_file_no_extension = expand("%:t:r")
    let current_file_with_extension = expand("%:t")
    execute a:pre_command
    call fzf#run(fzf#wrap({
      \ 'source': 'find -name ' . current_file_no_extension . '.* | grep -Ev *' . current_file_with_extension . '$',
      \ 'options': '--select-1', 'sink': a:sink}))
    execute a:post_command
endfunction
nnoremap <leader>ss :call FZFSameName('e', '', '')<CR>

" Remove obnoxious noises vim makes
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

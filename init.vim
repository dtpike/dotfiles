set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set noshowmode              " Don't show the mode since we're using lightline
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

" Plug 'nordtheme/vim'
Plug 'jasonlong/nord-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } 
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator' "tmux navigation
Plug 'mengelbrecht/lightline-bufferline' " buffer display
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'

Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'
Plug 'rhysd/vim-clang-format'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'danymat/neogen'
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}

" Tempoarily adding vsnip but should replace this with something else
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

call plug#end()

let mapleader=";"

" open vimrc
nnoremap <leader>ve :e $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>
" Automatically source vimrc on save (NOT WORKING with bufferline)
" autocmd BufWritePost $MYVIMRC source %

" colorscheme
set background=dark
colorscheme nord

" Wrapping
autocmd BufRead,BufNewFile *.md setlocal textwidth=79 cc=80
autocmd BufRead,BufNewFile *.rst setlocal tabstop=3 shiftwidth=3 expandtab
autocmd BufRead,BufNewFile *.py setlocal textwidth=88 cc=88

" Set groovy filetype for jenkins config files
autocmd BufNewFile,BufRead Jenkinsfile setf groovy

" fzf
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fa :Ag<CR>
nnoremap <leader>fb :Buffers<CR>
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-i': 'vsplit' }

" lightline/bufferline
let g:lightline = {
      \ 'colorscheme': 'nord',
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

" tmux-style navigation
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-h> <C-w>h
nnoremap <c-l> <C-w>l

nnoremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> {Previous-Mapping} :<C-U>TmuxNavigatePrevious<cr>
let g:tmux_navigator_save_on_switch = 1 " Save on switch


" tab/shift+tab to switch buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" commentary plugin uses /* style */ comments for C family, use '//' instead
autocmd FileType c setlocal commentstring=//\ %s 
autocmd FileType cpp setlocal commentstring=//\ %s 

"
" Completions
"""""""""""""
set completeopt=menuone,noinsert,noselect,preview

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
inoremap <expr> q       pumvisible() ? asyncomplete#cancel_popup() : "q"

"
" Formatting
"""""""""""""

" clang-format
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 1
let g:clang_format#auto_format_on_insert_leave = 0
let g:clang_format#auto_formatexpr = 0


"
" LSP settings
"""""""""""""""

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)

    nmap <buffer> gS            <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr            <plug>(lsp-references)
    nmap <buffer> gi            <plug>(lsp-implementation)
    nmap <buffer> gt            <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn    <plug>(lsp-rename)
    nmap <buffer> [g            <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g            <plug>(lsp-next-diagnostic)
    nmap <buffer> K             <plug>(lsp-hover)
    nmap <buffer> gf            :LspDocumentFormatSync<CR>

    let g:lsp_format_sync_timeout = 1000
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_hint = {'text': '#'}


let g:lsp_settings = {
\  'clangd': {'cmd': ['clangd-13', '--background-index', '--header-insertion=never', '--clang-tidy']},
\  'efm-langserver': {'disabled': v:false}
\}


lua << EOF
-----------------------------------------------
-- neovim-treesitter
-----------------------------------------------
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"cpp", "python"},
    -- Install asynchronously
    sync_install = false,
    -- Don't automatically install new parsers
    auto_install = false,
    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "c", "rust", "vim" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
  },
}
-----------------------------------------------
-- neogen
-----------------------------------------------
require'neogen'.setup {
    enabled = true,
    languages = {
        python = {
            template = { annotation_convention = "google_docstrings" }
        },
    }
}
EOF

"
" Neogen config for documentation
"""""""""""""""""""""""""""""""""
nnoremap <leader>df :Neogen func<CR>
nnoremap <leader>dc :Neogen class<CR>
nnoremap <leader>dd :Neogen<CR>

"
" vsnip config
""""""""""""""
" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
let g:vsnip_snippet_dir = '~/dotfiles/vsnip'

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

"
" Black
let g:black_virtualenv = "~/.venv"
let g:python3_host_prog = $HOME . '/.venv/bin/python3'

" vim.lsp.set_log_level("trace")

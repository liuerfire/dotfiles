" vim: set foldmarker={{{,}}} foldmethod=marker:

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" plugins {{{
call plug#begin()
" Appearance
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'liuchengxu/space-vim-theme'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'kaicataldo/material.vim'
Plug 'cseelus/vim-colors-lucid'

" Effective
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'tomtom/tcomment_vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Tool
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'svermeulen/vim-easyclip'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'editorconfig/editorconfig-vim'
Plug 'romainl/vim-cool/'
Plug 'luochen1990/rainbow'
Plug 'ntpeters/vim-better-whitespace'

" Fzf
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }

" Pane
Plug 'roman/golden-ratio'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

" Language
Plug 'sheerun/vim-polyglot'
Plug 'rust-lang/rust.vim'
Plug 'jparise/vim-graphql'
Plug 'nathangrigg/vim-beancount'

call plug#end()
" }}}

let mapleader = " "

" general settings {{{
set termguicolors
set nu
set ignorecase
set smartcase
set whichwrap+=<,>,h,l
set magic
set nobackup
set noswapfile
set cindent
set foldnestmax=1
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2
set mouse=n
set splitright
set splitbelow
set scrolloff=5
set nowrap
set cursorline
set list
set listchars=tab:‣\ ,eol:↵,trail:·,extends:↷,precedes:↶
set showbreak=↪
set inccommand=split
set clipboard=unnamed
" }}}

colorscheme dracula

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
autocmd FileType go setlocal shiftwidth=4 noexpandtab tabstop=4 shiftwidth=4

" my maps {{{
nmap <leader>ei :e ~/.config/nvim/init.vim<cr>
nmap <leader>el :e ~/.config/nvim/vimrc_local<cr>

nnoremap j gj
nnoremap k gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

tnoremap <Esc> <C-\><C-n>
nnoremap <leader>tv :vs term://zsh<CR>
nnoremap <leader>tn :new term://zsh<CR>
" }}}

if !has('mac')
  " I don't know why the relative path is not available
  let g:python3_host_prog="/usr/bin/python"
  let g:clipboard = {
    \   'name': 'xclip_neovim_clipboard',
    \   'copy': {
    \      '+': 'xclip -selection clipboard',
    \      '*': 'xclip -selection clipboard',
    \    },
    \   'paste': {
    \      '+': 'xclip -selection clipboard -o',
    \      '*': 'xclip -selection clipboard -o',
    \   },
    \   'cache_enabled': 1,
    \ }
else
  let g:python3_host_prog="python"
endif

" vim-clap {{{
nnoremap <leader>af :Clap files ++finder=fd --type f --hidden --exclude .git --no-ignore<CR>
nnoremap <leader>ff :Clap files<CR>
nnoremap <leader>bb :Clap buffers<CR>
nnoremap <leader>rg :Clap grep ++query=<cword><CR>

command! -nargs=* -bang Rg :Clap grep <args>
command! -nargs=* -bang Colors :Clap colors <args>
command! -nargs=* -bang Commands :Clap command <args>
command! -nargs=* -bang Maps :Clap maps <args>
" }}}

" fzf-vim {{{
" command! -nargs=? -complete=dir AF
"   \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
"   \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
"   \ })))
"
" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(), a:fullscreen)
" endfunction
"
" command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
" command! -bang -nargs=? -complete=dir Files
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
"
" nnoremap <leader>af :AF<CR>
" nnoremap <leader>ff :Files<CR>
" nnoremap <leader>rg :Rg <C-R><C-W><CR>
" nnoremap <leader>bb :Buffers<CR>
"
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" }}}

"vim-airline settings {{{
let g:airline_powerline_fonts = 1
" }}}

" Rainbow settings {{{
let g:rainbow_active = 1
" }}}

" better-whitespace {{{
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
" }}}

" golden ratio {{{
let g:golden_ratio_autocommand = 0
map <C-g> <Plug>(golden_ratio_resize)
" }}}

" easyclip {{{
nmap M m$
" }}}

" coc.nvim {{{
" if hidden is not set, TextEdit might fail.
set hidden

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

call coc#add_extension('coc-json', 'coc-lists', 'coc-python', 'coc-go',
                     \ 'coc-rust-analyzer', 'coc-snippets', 'coc-git',
                     \ 'coc-highlight', 'coc-pairs', 'coc-prettier')

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gvd :call CocAction('jumpDefinition', 'vnew')<CR>
nmap <silent> gxd :call CocAction('jumpDefinition', 'new')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" }}}

" local vimrc {{{
let s:local_vimrc = $HOME."/.config/nvim/vimrc_local"
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
" }}}

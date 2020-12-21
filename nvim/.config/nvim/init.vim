" vim: set foldmarker={{{,}}} foldmethod=marker:

" plugins {{{
call plug#begin()
" Appearance
Plug 'tomasiser/vim-code-dark'
Plug 'arzg/vim-colors-xcode'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ryanoasis/vim-devicons'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Tool
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'liuchengxu/vista.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'preservim/nerdtree'

" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

" Language
Plug 'sheerun/vim-polyglot'
Plug 'nathangrigg/vim-beancount'

call plug#end()
" }}}

let mapleader = " "

" general settings {{{
set hidden
set updatetime=300
set shortmess+=c
set termguicolors
set relativenumber
set number
set ignorecase
set smartcase
set nobackup
set noswapfile
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set foldnestmax=1
set mouse=n
set splitright
set splitbelow
set scrolloff=5
set cursorline
set list
set listchars=tab:‣\ ,eol:¬,trail:·,extends:↷,precedes:↶
set showbreak=↪
set inccommand=split
" Make diff great again: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience,indent-heuristic
" }}}

" autocmd {{{
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
autocmd FileType go setlocal noexpandtab
" }}}

" command {{{
command! -nargs=0 EditInit :e ~/.config/nvim/init.vim
command! -nargs=0 EditLocal :e ~/.config/nvim/local.vim
" }}}

" my maps {{{
" copy from https://github.com/junegunn/dotfiles/blob/master/vimrc
function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call s:map_change_option('w', 'wrap')
call s:map_change_option('b', 'background',
  \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>

nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <leader>n :nohl<CR>

nnoremap [q :cprev<cr>zz
nnoremap ]q :cnext<cr>zz
nnoremap [l :lprev<cr>zz
nnoremap ]l :lnext<cr>zz

nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>p "+p

cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <A-b> <S-Left>
cnoremap <C-f> <Right>
cnoremap <A-f> <S-Right>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>

tnoremap <Esc> <C-\><C-n>
" }}}

" python3 host {{{
let g:python3_host_prog="/usr/bin/python3"
" }}}

" statusline {{{
function! s:statusline_expr()
  let mod = "%{&modified ? ' []' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? ' []' : ''}"
  let coc = " %{coc#status()} %{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}"
  let sep = ' %= '
  let fileinfo  = ' %{WebDevIconsGetFileFormatSymbol()} %{&fenc}'
  let pos = ' [%l/%L:%c%V]'
  return ' %{WebDevIconsGetFileTypeSymbol()} %f%<'.mod.ro.coc.sep.fileinfo.pos
endfunction

let &statusline = s:statusline_expr()
" }}}

" colorizer {{{
lua require'colorizer'.setup()
" }}}

" fzf {{{
let $FZF_DEFAULT_OPTS .= ' --inline-info'

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

let g:fzf_layout = {'window': {'width': 0.7, 'height': 0.8}}
let g:fzf_preview_window = ['up:40%', 'ctrl-/']

command! -nargs=? -complete=dir AF
  \ call fzf#run(fzf#wrap(fzf#vim#with_preview({
  \   'source': 'fd --type f --hidden --follow --exclude .git --no-ignore . '.expand(<q-args>)
  \ })))

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.(len(<q-args>) > 0 ? <q-args> : '""'), 1,
  \   fzf#vim#with_preview('up', 'ctrl-/'), <bang>0)

nnoremap <leader>ff :Files<CR>
nnoremap <leader>af :AF<CR>
nnoremap <leader>rg :Rg <C-R><C-W><CR>
nnoremap <leader>bb :Buffers<CR>
xnoremap <leader>rg y:Rg <C-R>"<CR>
" }}}

" better-whitespace {{{
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
" }}}

" NERDTree {{{
nnoremap <leader>ee :NERDTreeToggle<CR>
" }}}

" coc.nvim {{{
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-pyright',
  \ 'coc-go',
  \ 'coc-rust-analyzer',
  \ 'coc-snippets',
  \ 'coc-git',
  \ 'coc-prettier'
  \ ]

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
nmap <silent> gtd :call CocAction('jumpDefinition', 'tabnew')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>gc <Plug>(coc-git-commit)

nnoremap <silent> <leader>cd :<C-u>CocList -A diagnostics<CR>
nnoremap <silent> <leader>co :<C-u>CocList -A outline -kind<CR>

command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Format :call CocAction('format')

autocmd FileType go command! -nargs=? GoAddTags :CocCommand go.tags.add <args>
autocmd FileType go command! -nargs=? GoRemoveTags :CocCommand go.tags.remove <args>

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" }}}

" vimrc for localhost {{{
let s:local_vimrc = expand("<sfile>:p:h").'/local.vim'
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
" }}}

" vimrc for a project {{{
let s:p_vimrc = ".vim/vimrc"
if filereadable(s:p_vimrc)
  execute 'source' s:p_vimrc
endif
" }}}

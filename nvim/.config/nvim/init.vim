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
Plug 'rafalbromirski/vim-aurora'
Plug 'rakr/vim-one'
Plug 'gruvbox-community/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ryanoasis/vim-devicons'

" Effective
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'tomtom/tcomment_vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Tool
Plug 'svermeulen/vim-easyclip'
Plug 'godlygeek/tabular'
Plug 'liuchengxu/vista.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'romainl/vim-cool'
Plug 'luochen1990/rainbow'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth'

" Fzf
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

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
set relativenumber
set number
set ignorecase
set smartcase
set whichwrap+=<,>,h,l
set magic
set nobackup
set noswapfile
set foldnestmax=1
set mouse=n
set splitright
set splitbelow
set scrolloff=5
set nowrap
set cursorline
set list
set listchars=tab:‣\ ,eol:¬,trail:·,extends:↷,precedes:↶
set showbreak=↪
set inccommand=split
set clipboard=unnamed
" }}}

" autocmd {{{
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" }}}

" command {{{
command! -nargs=0 EditInit :e ~/.config/nvim/init.vim
command! -nargs=0 EditLocal :e ~/.config/nvim/local.vim
" }}}

" my maps {{{
inoremap <C-a> <Home>
inoremap <C-e> <End>

nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

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
nnoremap <leader>tv :vs term://zsh<CR>
nnoremap <leader>tn :new term://zsh<CR>
" }}}

" clipboard {{{
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
" }}}

" leaderf {{{
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseMemoryCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_PreviewResult = {'File': 1, 'Rg': 1}
let g:Lf_CommandMap = {'<C-]>': ['<C-V>']}
let g:Lf_ShowHidden = 1
let g:Lf_AutoReisze = 1
let g:Lf_WildIgnore = {
  \ 'dir': ['.svn','.git','.hg','node_modules'],
  \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
  \ }

let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>af :<C-U><C-R>=printf("Leaderf file --no-ignore %s", "")<CR><CR>
noremap <leader>bb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>rg :<C-U><C-R>=printf("Leaderf rg -e %s ", expand("<cword>"))<CR><CR>
xnoremap <leader>rg :<C-U><C-R>=printf("Leaderf rg -F -e %s ", leaderf#Rg#visual())<CR><CR>

command! -nargs=* -bang Rg :Leaderf rg <args>
command! -nargs=0 -bang Colors :LeaderfColorscheme
command! -nargs=* -bang Commands :LeaderfCommand
" }}}

" Vista {{{
let g:vista_default_executive = 'coc'
" }}}

"vim-airline {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#coc_git = 1
let g:airline_powerline_fonts = 1
" }}}

" Rainbow {{{
let g:rainbow_active = 1
" }}}

" better-whitespace {{{
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
" }}}

" golden ratio {{{
let g:golden_ratio_autocommand = 0
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

call coc#add_extension('coc-explorer', 'coc-json', 'coc-lists', 'coc-python',
                     \ 'coc-go', 'coc-rust-analyzer', 'coc-snippets', 'coc-git',
                     \ 'coc-highlight', 'coc-prettier')

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
nmap <silent> <leader>rn <Plug>(coc-rename)

nnoremap <silent> <leader>cd :<C-u>CocList -A diagnostics<CR>
nnoremap <silent> <leader>co :<C-u>CocList -A outline -kind<CR>
nnoremap <silent> <leader>ee :<C-u>CocCommand explorer<CR>

command! -nargs=0 Maps :CocList maps
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Format :call CocAction('format')

autocmd FileType go command! -nargs=? GoAddTags :CocCommand go.tags.add <args>
autocmd FileType go command! -nargs=? GoDeleteags :CocCommand go.tags.remove <args>

autocmd CursorHold * silent call CocActionAsync('highlight')

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

set background=dark
highlight clear

let g:colors_name = 'liuerdark'
if exists('syntax_on')
  syntax reset
endif

highlight Normal gui=none guifg=#ffffff guibg=#1e1e1e
highlight Comment gui=none guifg=#767676
highlight Constant gui=none guifg=#87afff
highlight String gui=none guifg=#ce9178
highlight Character gui=none guifg=#ffaf00
highlight Number gui=none guifg=#5fdfff
highlight Boolean gui=none guifg=#d7ba7d
highlight Float gui=none guifg=#5fffaf

highlight Identifier gui=none guifg=#87dfff
highlight Function gui=none guifg=#dcdcaa

highlight Statement gui=none guifg=#5d9cd6
highlight Conditional gui=none guifg=#ef7f00
highlight default link Repeat Statement
highlight default link Label Statement
highlight Operator gui=none guifg=#ffdf00
highlight default link Keyword Statement
highlight default link Exception Statement

highlight PreProc gui=none guifg=#00afff
highlight Include gui=none guifg=#00afdf
highlight Define gui=none guifg=#00afaf
highlight Macro gui=none guifg=#00af87
highlight PreCondit gui=none guifg=#00af5f

highlight Type gui=none guifg=#de935f
highlight StorageClass gui=none guifg=#ff7fff
highlight Structure gui=none guifg=#ff7fdf
highlight Typedef gui=none guifg=#ff7faf

highlight Special gui=none guifg=orange
highlight SpecialChar gui=none guifg=orange
highlight Tag gui=none guifg=orange
highlight Delimiter gui=none guifg=orange
highlight SpecialComment gui=none guifg=violet
highlight Debug gui=none guifg=violet

highlight TabLine guifg=#dadada guibg=#606060
highlight TabLineFill guifg=#dadada guibg=#606060
highlight TabLineSel guifg=#dadada
highlight Visual guibg=#585858
highlight default link VisualNOS Visual
highlight Underlined gui=underline guifg=#00dfff
highlight Error gui=none guifg=#ffffff guibg=#af0000
highlight WarningMsg gui=none guifg=#c0c0c0 guibg=#000000
highlight WildMenu guibg=#ffaf00
highlight Todo gui=none guifg=#dfdf5f guibg=NONE
highlight DiffAdd guifg=fg guibg=#005f00
highlight DiffChange guifg=fg guibg=#5f0000
highlight DiffDelete guifg=fg guibg=#870000
highlight DiffText guifg=fg guibg=#df0000
highlight DiffFile guifg=#00ff5f guibg=bg
highlight DiffNewFile guifg=#ff00af guibg=bg
highlight default link DiffRemoved DiffDelete
highlight DiffLine guifg=#af00ff guibg=bg
highlight default link DiffAdded DiffAdd
highlight default link ErrorMsg Error
highlight Ignore gui=none guifg=bg
highlight ModeMsg guifg=bg guibg=bg

highlight VertSplit gui=none guifg=black guibg=darkgray gui=none
highlight Folded guifg=#9e9e9e guibg=#262626
highlight FoldColumn guifg=#9e9e9e guibg=#262626
highlight SignColumn guifg=#9e9e9e guibg=#262626
highlight SpecialKey gui=none guifg=darkgray
highlight NonText gui=none guifg=#373b41
highlight StatusLine gui=none guifg=#1c1c1c guibg=#eeeeee
highlight StatusLineNC gui=none guifg=#262626 guibg=#585858
highlight CursorLine gui=none guibg=#424450
highlight CursorLineNr gui=bold guifg=#afdf00 guibg=#262626
highlight ColorColumn gui=none guibg=#4e4e4e
highlight Cursor gui=reverse guifg=NONE guibg=NONE
highlight CursorColumn gui=none guibg=#262626
highlight LineNr guifg=#5f5f00 guibg=bg
highlight MatchParen guibg=#4e4e4e
highlight Pmenu gui=none guifg=#b2b2b2 guibg=#2d2d2d
highlight PmenuSel gui=none guifg=#121212 guibg=#666666
highlight PmenuSbar gui=none guifg=#121212 guibg=#808080
highlight PmenuThumb gui=none guifg=#121212 guibg=#4e4e4e
highlight Search gui=reverse guifg=#dfaf00 guibg=#303030
highlight IncSearch gui=reverse guifg=#af8700 guibg=#303030
highlight QuickFixLine gui=bold guifg=NONE guibg=NONE
highlight SpellBad gui=none guibg=#5f0000
highlight default link SpellCap SpellBad
highlight default link SpellLocal SpellBad
highlight default link SpellRare SpellBad

if exists('##CmdlineEnter')
  highlight IncSearch gui=reverse guifg=#dfaf00 guibg=#303030
  augroup liuerdark-highlight-search
    autocmd!
    autocmd CmdlineEnter /,\? :highlight Search gui=reverse guifg=#878700 guibg=#303030
    autocmd CmdlineLeave /,\? :highlight Search gui=reverse guifg=#dfaf00 guibg=#303030
  augroup END
endif

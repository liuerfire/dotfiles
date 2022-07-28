vim.opt.termguicolors = true
vim.opt.mouse = 'n'
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = 'tab:⇢ ,eol:¬,trail:·,extends:↷,precedes:↶'
vim.opt.showbreak = '↪'
vim.opt.hidden = true
vim.opt.lazyredraw = true
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.completeopt = 'menu,menuone,noselect'

vim.wo.foldlevel = 99
vim.wo.foldenable = true

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight on yank',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go,make',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java,c,cpp',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]],
  desc = 'jump to the last position',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'init.lua',
  command = [[source <afile> | PackerCompile]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = "*",
  command = [[ set fo-=c fo-=r fo-=o ]],
  desc = 'do not auto commenting new lines',
})

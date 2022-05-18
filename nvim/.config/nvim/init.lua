local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'liuerfire/vim-code-dark'
  use 'sainnhe/edge'
  use 'eemed/sitruuna.vim'
  use 'Mofiqul/adwaita.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'kyazdani42/nvim-web-devicons'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'kyazdani42/nvim-tree.lua'
  use 'machakann/vim-sandwich'
  use 'editorconfig/editorconfig-vim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'junegunn/vim-easy-align'

  use 'nathangrigg/vim-beancount'
  use 'google/vim-jsonnet'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'j-hui/fidget.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
    }
  }

  use {
    'neovim/nvim-lspconfig',
    requires = {
      "williamboman/nvim-lsp-installer",
      'folke/trouble.nvim',
      "ray-x/lsp_signature.nvim",
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'rafamadriz/friendly-snippets',
    },
  }

end)

opt.termguicolors = true
opt.mouse = 'a'
opt.swapfile = false
opt.relativenumber = true
opt.number = true
opt.showmatch = true
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.listchars='tab:⇢ ,eol:¬,trail:·,extends:↷,precedes:↶'
opt.showbreak='↪'
opt.hidden = true
opt.lazyredraw = true
opt.inccommand = 'split'
opt.laststatus = 3

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.completeopt = 'menu,menuone,noselect'

-- Highlight on yank
cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

cmd [[
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
  autocmd FileType go,make setlocal shiftwidth=4 tabstop=4 noexpandtab
  autocmd FileType java setlocal shiftwidth=4 tabstop=4
]]

map('', '<Space>', '<Nop>', default_opts)
g.mapleader = ' '
g.maplocalleader = ' '

-- Get rid of annoying ex keybind
vim.api.nvim_set_keymap('', 'Q', '<Nop>', default_opts)

map('n', '<leader>n', ':nohl<CR>', default_opts)
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

map('n', '<A-.>', ':tabn<CR>', default_opts)
map('n', '<A-,>', ':tabp<CR>', default_opts)

map('n', '<C-h>', '<C-w>h', default_opts)
map('n', '<C-j>', '<C-w>j', default_opts)
map('n', '<C-k>', '<C-w>k', default_opts)
map('n', '<C-l>', '<C-w>l', default_opts)
map('i', '<C-a>', '<Home>', default_opts)
map('i', '<C-e>', '<End>', default_opts)

map('n', '<leader>p', '"+p', default_opts)
map('n', '<leader>P', '"+P', default_opts)
map('x', '<leader>p', '"+p', default_opts)
map('v', '<leader>y', '"+y', default_opts)
map('n', 'Y', 'y$', { noremap = true })

require('colorizer').setup()

require('nvim-tree').setup()

map('n', '<leader>ee', ':NvimTreeToggle<CR>', default_opts)

require('indent_blankline').setup{
  filetype = { 'python', 'yaml' }
}

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<ESC>'] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}
telescope.load_extension('fzf')

cmd [[
  command! AF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git,--no-ignore previewer=false
  command! FF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git, previewer=false
]]
map('n', '<leader>af', ':AF<CR>', default_opts)
map('n', '<leader>ff', ':FF<CR>', default_opts)
map('n', '<leader>bb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], default_opts)
map('n', '<leader>rg', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], default_opts)
map('n', '<leader>co', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], default_opts)
map('n', '<leader>/', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], default_opts)

require("nvim-lsp-installer").setup{
  ensure_installed = { 'pyright', 'gopls', 'rust_analyzer', 'tsserver' }
}

local lspconfig = require('lspconfig')

require('lsp_signature').setup()
require('trouble').setup {
  auto_close = true,
}
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', {silent = true, noremap = true})
map('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', {silent = true, noremap = true})
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', {silent = true, noremap = true})

map('n', 'gi', '<cmd>Trouble lsp_implementations<cr>', {silent = true, noremap = true})
map('n', 'gr', '<cmd>Trouble lsp_references<cr>', {silent = true, noremap = true})

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gxd', '<cmd>split <bar> lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'gvd', '<cmd>vsplit <bar> lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'clangd', 'gopls', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

cmd [[
  autocmd BufWritePre *.go,*.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
]]

local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  -- load snippet support
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  -- key mapping
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),

  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}

require('fidget').setup()

if vim.fn.filereadable(vim.fn.stdpath 'config' .. '/lua/local.lua') == 1 then
  require('local')
end

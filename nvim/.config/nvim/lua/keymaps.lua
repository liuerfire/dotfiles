vim.keymap.set('', '<Space>', '<nop>')
vim.g.mapleader = ' '

-- Get rid of annoying ex keybind
vim.keymap.set('', 'Q', '<nop>')

vim.keymap.set('n', '<leader>n', '<cmd>nohl<cr>')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set('n', '<A-.>', '<cmd>tabn<cr>')
vim.keymap.set('n', '<A-,>', '<cmd>tabp<cr>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('i', '<C-a>', '<Home>')
vim.keymap.set('i', '<C-e>', '<End>')

vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('x', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', 'Y', 'y$')

vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<cr>')

vim.cmd [[
  command! AF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git,--no-ignore previewer=false
  command! FF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git, previewer=false
]]
vim.keymap.set('n', '<leader>af', '<cmd>AF<CR>')
vim.keymap.set('n', '<leader>ff', '<cmd>FF<CR>')
vim.keymap.set('n', '<leader>bb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>rg', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>co', require('telescope.builtin').lsp_document_symbols)
vim.keymap.set('n', '<leader>/', require('telescope').extensions.live_grep_args.live_grep_args)

vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gxd', '<cmd>split <bar> lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', 'gvd', '<cmd>vsplit <bar> lua vim.lsp.buf.definition()<cr>')
vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'gr', function() require('trouble').toggle({ mode = 'lsp_references' }) end)
vim.keymap.set('n', 'gi', function() require('trouble').toggle({ mode = 'lsp_implementations' }) end)
vim.keymap.set('n', '<leader>xd', function() require('trouble').toggle({ mode = 'document_diagnostics' }) end)
vim.keymap.set('n', '<leader>xw', function() require('trouble').toggle({ mode = 'workspace_diagnostics' }) end)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)

vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})

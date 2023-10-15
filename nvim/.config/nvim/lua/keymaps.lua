vim.keymap.set("", "<Space>", "<nop>")
vim.g.mapleader = " "

-- Get rid of annoying ex keybind
vim.keymap.set("", "Q", "<nop>")

vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<A-.>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<A-,>", "<cmd>bprevious<cr>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-b>", "<Left>")

vim.keymap.set("n", "<leader>p", '"+p')
vim.keymap.set("n", "<leader>P", '"+P')
vim.keymap.set("x", "<leader>p", '"+p')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "Y", "y$")

vim.api.nvim_create_user_command("CopyFilePath", function()
  vim.fn.system("wl-copy", vim.fn.expand("%"))
end, {})
vim.api.nvim_create_user_command("CopyFileAbsPath", function()
  vim.fn.system("wl-copy", vim.fn.expand("%:p"))
end, {})

vim.api.nvim_create_user_command("TrimSpace", function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)
  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end, {})

vim.cmd([[
  command! AF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git,--no-ignore previewer=false
  command! FF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git, previewer=false
]])
vim.keymap.set("n", "<leader>af", "<cmd>AF<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>FF<CR>")
vim.keymap.set("n", "<leader>bb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>rg", require("telescope.builtin").grep_string)
vim.keymap.set("n", "<leader>co", require("telescope.builtin").lsp_document_symbols)
vim.keymap.set("n", "<leader>/", require("telescope").extensions.live_grep_args.live_grep_args)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gxd", "<cmd>split <bar> lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gvd", "<cmd>vsplit <bar> lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gtd", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>")
vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gi", function()
  require("telescope.builtin").lsp_implementations({ show_line = false })
end)
vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references({ show_line = false })
end)
vim.keymap.set("n", "<leader>xx", require("telescope.builtin").diagnostics)
vim.keymap.set("n", "<leader>xb", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

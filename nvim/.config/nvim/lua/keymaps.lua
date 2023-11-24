vim.keymap.set("", "<Space>", "<nop>")
vim.g.mapleader = " "

-- Get rid of annoying ex keybind
vim.keymap.set("", "Q", "<nop>")

vim.keymap.set("n", "<leader>n", "<cmd>nohl<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<A-.>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<A-,>", "<cmd>tabprevious<cr>")

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

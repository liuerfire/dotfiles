local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    layout_strategy = "vertical",
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
        ["<C-[>"] = actions.close,
      },
    },
    dynamic_preview_title = true,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        -- even more opts
      }),
    },
  },
})
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")

vim.cmd([[
  command! AF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git,--no-ignore previewer=false
  command! FF :Telescope find_files find_command=fd,--type,f,--hidden,--follow,--exclude,.git, previewer=false
]])
vim.keymap.set("n", "<leader>af", "<cmd>AF<CR>")
vim.keymap.set("n", "<leader>ff", "<cmd>FF<CR>")
vim.keymap.set("n", "<leader>bb", builtin.buffers)
vim.keymap.set("n", "<leader>rg", builtin.grep_string)
vim.keymap.set("n", "<leader>xx", builtin.diagnostics)
vim.keymap.set("n", "<leader>co", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>xb", function()
  builtin.diagnostics({ bufnr = 0 })
end)
vim.keymap.set("n", "gi", function()
  builtin.lsp_implementations({ show_line = false })
end)
vim.keymap.set("n", "gr", function()
  builtin.lsp_references({ show_line = false })
end)

vim.keymap.set("n", "<leader>/", require("telescope").extensions.live_grep_args.live_grep_args)

local telescope = require("telescope")
local actions = require("telescope.actions")

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
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--hidden",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim",
      "-g",
      "!.git",
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

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<ESC>'] = actions.close,
        -- needed when in kitty. See: https://sw.kovidgoyal.net/kitty/keyboard-protocol/
        ['<C-[>'] = actions.close,
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
      "--trim"
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {
        -- even more opts
      }
    },
  },
}
telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('ui-select')
